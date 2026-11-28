;;; agy-review.el --- Inline & Magit code review workflow for ghostel + agy -*- lexical-binding: t; -*-

;; Author: Srikkant
;; Keywords: tools, vc, convenience
;; Package-Requires: ((emacs "29.1"))

;;; Commentary:

;; A lightweight code-review workflow for Emacs that lets you annotate
;; source files and Magit diffs with inline overlays, inspect/edit
;; queued comments in a review list buffer, and flush them as structured
;; prompts into a per-project `ghostel' buffer running `agy'.

;;; Code:

(require 'cl-lib)
(require 'eieio)
(require 'project)
(require 'subr-x)

(defvar ghostel--process)
(defvar magit-root-section)

(declare-function ghostel-exec "ghostel" (buffer program &optional args))
(declare-function ghostel-paste-string "ghostel" (string))
(declare-function ghostel-send-string "ghostel" (string))
(declare-function ghostel-send-key "ghostel" (key-name &optional mods))

(declare-function magit-toplevel "magit-git" (&optional directory))
(declare-function magit-file-at-point "magit-diff" (&optional assert))
(declare-function magit-current-section "magit-section" ())
(declare-function magit-diff-hunk-line "magit-diff" (section goto-from))

;;; Customization & Faces

(defgroup agy-review nil
  "Review code in Emacs/Magit and send batch annotations to agy in ghostel."
  :group 'tools)

(defcustom agy-review-command "agy"
  "Command to launch Antigravity inside ghostel."
  :type 'string)

(defcustom agy-review-use-login-shell t
  "When non-nil, launch `agy-review-command' via a login shell.
This ensures GUI Emacs inherits PATH entries such as ~/.local/bin."
  :type 'boolean)

(defcustom agy-review-buffer-name-format "*agy:%s*"
  "Format string for per-project agy ghostel buffer names.
Receives the project directory basename as its single argument."
  :type 'string)

(defcustom agy-review-auto-submit nil
  "When non-nil, `agy-review-flush' sends Return after pasting.
Passing a prefix argument to `agy-review-flush' toggles this behavior."
  :type 'boolean)

(defcustom agy-review-prompt-header
  "Please address the following code review comments:"
  "Header line prepended to flushed review batches."
  :type 'string)

(defface agy-review-annotation-face
  '((t :inherit warning :box (:line-width -1) :weight bold))
  "Face used for inline review annotation overlays.")

(defface agy-review-list-location-face
  '((t :inherit font-lock-function-name-face :weight bold))
  "Face used for file:line locations in the review list buffer.")

(defface agy-review-list-snippet-face
  '((t :inherit shadow))
  "Face used for code snippets in the review list buffer.")

;;; Data Model & Per-Project State

(cl-defstruct (agy-review-entry
               (:constructor agy-review-entry-create))
  id
  root
  file
  abs-file
  line
  end-line
  side
  snippet
  note)

(defvar agy-review--next-id 1
  "Monotonically increasing ID for review entries.")

(defvar agy-review--buffers (make-hash-table :test #'equal)
  "Map from canonical project root to its active ghostel buffer.")

(defvar agy-review--entries (make-hash-table :test #'equal)
  "Map from canonical project root to a list of `agy-review-entry' structs.")

(defvar-local agy-review--root nil
  "Canonical project root associated with this helper buffer.")

(defun agy-review--canonical-dir (dir)
  "Return DIR as an expanded directory name with trailing slash."
  (file-name-as-directory (expand-file-name dir)))

(defun agy-review--project-root ()
  "Return the canonical project root for the current context."
  (cond
   (agy-review--root
    (agy-review--canonical-dir agy-review--root))
   ((and (derived-mode-p 'magit-mode)
         (fboundp 'magit-toplevel)
         (magit-toplevel))
    (agy-review--canonical-dir (magit-toplevel)))
   ((when-let* ((proj (project-current)))
      (agy-review--canonical-dir (project-root proj))))
   (t
    (agy-review--canonical-dir default-directory))))

(defun agy-review--project-name (root)
  "Return a short display name for canonical ROOT."
  (let ((name (file-name-nondirectory (directory-file-name root))))
    (if (string-empty-p name) "root" name)))

(defun agy-review--get-entries (root)
  "Return the list of `agy-review-entry' items for ROOT."
  (gethash root agy-review--entries))

(defun agy-review--set-entries (root entries)
  "Store ENTRIES for ROOT, deleting the key when empty."
  (if entries
      (puthash root entries agy-review--entries)
    (remhash root agy-review--entries)))

(defun agy-review--find-entry (root id)
  "Find entry with ID under ROOT."
  (cl-find-if (lambda (entry) (eql (agy-review-entry-id entry) id))
              (agy-review--get-entries root)))

;;; Ghostel Session Management & Dispatch

(defun agy-review--ghostel-live-p (buf)
  "Return non-nil if BUF is a live `ghostel-mode' buffer with a live process."
  (and (buffer-live-p buf)
       (with-current-buffer buf
         (and (derived-mode-p 'ghostel-mode)
              (or (and (boundp 'ghostel--process)
                       (process-live-p ghostel--process))
                  (process-live-p (get-buffer-process buf)))))))

(defun agy-review--live-ghostel-buffers ()
  "Return a list of all live ghostel buffers."
  (cl-remove-if-not #'agy-review--ghostel-live-p (buffer-list)))

(defun agy-review--launch-args ()
  "Return (PROGRAM . ARGS) for launching `agy-review-command'."
  (if agy-review-use-login-shell
      (let ((shell (or (getenv "SHELL") "/bin/zsh")))
        (cons shell (list "-lic" (concat "exec " agy-review-command))))
    (let ((parts (split-string-and-unquote agy-review-command)))
      (unless parts
        (user-error "`agy-review-command' is empty"))
      (cons (car parts) (cdr parts)))))

(defun agy-review--register-buffer (root buf)
  "Associate ghostel BUF with canonical ROOT and clean up on kill."
  (puthash root buf agy-review--buffers)
  (with-current-buffer buf
    (add-hook 'kill-buffer-hook
              (let ((tracked-root root)
                    (tracked-buf buf))
                (lambda ()
                  (when (eq (gethash tracked-root agy-review--buffers) tracked-buf)
                    (remhash tracked-root agy-review--buffers))))
              nil t)))

(defun agy-review--display-terminal-buffer (buf)
  "Display BUF in a suitable window before spawning ghostel."
  (if (one-window-p)
      (let ((win (split-window-right)))
        (select-window win)
        (switch-to-buffer buf))
    (pop-to-buffer buf)))

;;;###autoload
(defun agy-review-start (&optional force-new)
  "Open or switch to the per-project ghostel buffer running `agy-review-command'.
With prefix argument FORCE-NEW, start a fresh session even if one is live."
  (interactive "P")
  (let* ((root (agy-review--project-root))
         (existing (gethash root agy-review--buffers)))
    (if (and (not force-new) (agy-review--ghostel-live-p existing))
        (progn
          (pop-to-buffer existing)
          existing)
      (require 'ghostel)
      (let* ((base-name (format agy-review-buffer-name-format
                                (agy-review--project-name root)))
             (existing-named (get-buffer base-name))
             (buf (cond
                   ((and existing-named (agy-review--ghostel-live-p existing-named))
                    (generate-new-buffer base-name))
                   (existing-named
                    (with-current-buffer existing-named
                      (let ((inhibit-read-only t))
                        (erase-buffer)))
                    existing-named)
                   (t
                    (get-buffer-create base-name))))
             (cmd (agy-review--launch-args)))
        (with-current-buffer buf
          (setq default-directory root))
        (agy-review--display-terminal-buffer buf)
        (ghostel-exec buf (car cmd) (cdr cmd))
        (agy-review--register-buffer root buf)
        buf))))

;;;###autoload
(defun agy-review-attach (&optional buffer)
  "Attach an existing live ghostel BUFFER to the current project."
  (interactive)
  (let* ((root (agy-review--project-root))
         (live (agy-review--live-ghostel-buffers)))
    (unless live
      (user-error "No live ghostel buffers found; start one with `agy-review-start'"))
    (let* ((chosen (or buffer
                       (get-buffer
                        (completing-read
                         (format "Attach ghostel buffer to %s: "
                                 (agy-review--project-name root))
                         (mapcar #'buffer-name live)
                         nil t)))))
      (unless (agy-review--ghostel-live-p chosen)
        (user-error "Buffer %s is not a live ghostel session" chosen))
      (agy-review--register-buffer root chosen)
      (message "Attached %s to %s" (buffer-name chosen) (agy-review--project-name root))
      chosen)))

(defun agy-review--send-to-ghostel (buf text &optional submit)
  "Send TEXT to ghostel BUF using bracketed paste.
If SUBMIT is non-nil, send a Return key afterwards."
  (unless (agy-review--ghostel-live-p buf)
    (user-error "No live agy ghostel buffer. Launch it first with `agy-review-start'"))
  (with-current-buffer buf
    (cond
     ((fboundp 'ghostel-paste-string)
      (ghostel-paste-string text))
     ((fboundp 'ghostel-send-string)
      (ghostel-send-string (concat "\e[200~" text "\e[201~")))
     (t
      (let ((proc (or (and (boundp 'ghostel--process) ghostel--process)
                      (get-buffer-process buf))))
        (process-send-string proc (concat "\e[200~" text "\e[201~")))))
    (when submit
      (cond
       ((fboundp 'ghostel-send-key)
        (ghostel-send-key "return"))
       ((fboundp 'ghostel-send-string)
        (ghostel-send-string "\r"))
       (t
        (let ((proc (or (and (boundp 'ghostel--process) ghostel--process)
                        (get-buffer-process buf))))
          (process-send-string proc "\r")))))))

;;; Target Resolution (Normal Files & Magit Diffs)

(defun agy-review--slot (obj slot)
  "Read SLOT from EIEIO object OBJ."
  (funcall #'eieio-oref obj slot))

(defun agy-review--magit-file-at-point ()
  "Return the relative file path at point in a Magit buffer, or nil."
  (or (and (fboundp 'magit-file-at-point) (magit-file-at-point))
      (when (fboundp 'magit-current-section)
        (let ((sec (magit-current-section)))
          (while (and sec (not (eq (agy-review--slot sec 'type) 'file)))
            (setq sec (agy-review--slot sec 'parent)))
          (when sec (agy-review--slot sec 'value))))))

(defun agy-review--magit-pos-info (section pos)
  "Return (SIDE . LINE) for POS inside Magit hunk SECTION."
  (save-excursion
    (goto-char pos)
    (let* ((deleted (eq (char-after (line-beginning-position)) ?-))
           (side (if deleted 'old 'new))
           (line (magit-diff-hunk-line section deleted)))
      (cons side line))))

(defun agy-review--resolve-magit-target ()
  "Resolve target plist at point from a Magit diff or status buffer."
  (let* ((toplevel (and (fboundp 'magit-toplevel) (magit-toplevel)))
         (rel-raw (agy-review--magit-file-at-point)))
    (unless (and toplevel rel-raw)
      (user-error "Point is not on a valid file or diff hunk"))
    (let* ((root (agy-review--canonical-dir toplevel))
           (abs-file (expand-file-name rel-raw root))
           (rel-file (file-relative-name abs-file root))
           (sec (and (fboundp 'magit-current-section) (magit-current-section)))
           (line nil)
           (end-line nil)
           (side 'new)
           (snippet nil))
      (when (and sec (eq (agy-review--slot sec 'type) 'hunk))
        (let ((content (agy-review--slot sec 'content))
              (sec-end (agy-review--slot sec 'end)))
          (if (use-region-p)
              (let* ((beg (max (region-beginning) content))
                     (raw-end (min (region-end) sec-end))
                     (end-pos (if (and (> raw-end beg)
                                       (save-excursion (goto-char raw-end) (bolp)))
                                  (1- raw-end)
                                raw-end))
                     (start-info (agy-review--magit-pos-info sec beg))
                     (end-info (agy-review--magit-pos-info sec end-pos)))
                (if (and (eq (car start-info) 'old)
                         (eq (car end-info) 'old))
                    (setq side 'old
                          line (cdr start-info)
                          end-line (cdr end-info))
                  (setq side 'new
                        line (save-excursion
                               (goto-char beg)
                               (magit-diff-hunk-line sec nil))
                        end-line (save-excursion
                                   (goto-char end-pos)
                                   (magit-diff-hunk-line sec nil))))
                (when (and line end-line (<= end-line line))
                  (setq end-line nil))
                (let ((reg-beg (save-excursion
                                 (goto-char beg)
                                 (line-beginning-position)))
                      (reg-end (save-excursion
                                 (goto-char end-pos)
                                 (line-end-position))))
                  (when (<= reg-beg reg-end)
                    (setq snippet (buffer-substring-no-properties reg-beg reg-end)))))
            (if (< (point) content)
                (setq side 'new
                      line (magit-diff-hunk-line sec nil))
              (let ((info (agy-review--magit-pos-info sec (point))))
                (setq side (car info)
                      line (cdr info))
                (when (eq side 'old)
                  (setq snippet (buffer-substring-no-properties
                                 (line-beginning-position)
                                 (line-end-position)))))))))
      (list :root root
            :file rel-file
            :abs-file abs-file
            :line line
            :end-line end-line
            :side side
            :snippet snippet))))

(defun agy-review--resolve-file-target ()
  "Resolve target plist at point from a regular file-visiting buffer."
  (let ((buf-file (buffer-file-name)))
    (unless buf-file
      (user-error "Current buffer is not visiting a file"))
    (let* ((root (agy-review--project-root))
           (abs-file (expand-file-name buf-file))
           (rel-file (file-relative-name abs-file root))
           (line nil)
           (end-line nil)
           (snippet nil))
      (if (use-region-p)
          (let* ((beg (region-beginning))
                 (raw-end (region-end))
                 (end-pos (if (and (> raw-end beg)
                                   (save-excursion (goto-char raw-end) (bolp)))
                              (1- raw-end)
                            raw-end)))
            (setq line (line-number-at-pos beg)
                  end-line (line-number-at-pos end-pos))
            (when (<= end-line line)
              (setq end-line nil))
            (setq snippet (string-trim-right
                           (buffer-substring-no-properties beg raw-end)
                           "\n")))
        (setq line (line-number-at-pos)))
      (list :root root
            :file rel-file
            :abs-file abs-file
            :line line
            :end-line end-line
            :side 'new
            :snippet snippet))))

(defun agy-review--resolve-target ()
  "Resolve target plist at point in either Magit or a regular file buffer."
  (if (derived-mode-p 'magit-diff-mode 'magit-status-mode)
      (agy-review--resolve-magit-target)
    (agy-review--resolve-file-target)))

;;; Formatting & Overlays

(defun agy-review--format-location (entry)
  "Format file and line range of ENTRY for display or prompt output."
  (let* ((file (agy-review-entry-file entry))
         (line (agy-review-entry-line entry))
         (end-line (agy-review-entry-end-line entry))
         (side (agy-review-entry-side entry))
         (loc (cond
               ((null line) file)
               ((and end-line (> end-line line))
                (format "%s:%d-%d" file line end-line))
               (t (format "%s:%d" file line)))))
    (if (eq side 'old)
        (concat loc " (deleted)")
      loc)))

(defun agy-review--entry-summary (entry)
  "Return a single-line truncated summary of ENTRY's note."
  (let* ((note (agy-review-entry-note entry))
         (first-line (car (split-string note "\n" t))))
    (truncate-string-to-width (or first-line "") 60 nil nil "...")))

(defun agy-review--clear-buffer-overlays (buf)
  "Remove all `agy-review' overlays from BUF."
  (when (buffer-live-p buf)
    (with-current-buffer buf
      (dolist (ov (overlays-in (point-min) (point-max)))
        (when (overlay-get ov 'agy-review)
          (delete-overlay ov))))))

(defun agy-review--place-overlay-at-point (entry)
  "Place an inline `agy-review' overlay for ENTRY on the current line."
  (let ((ov (make-overlay (line-beginning-position) (line-end-position)))
        (label (format "  [AGY #%d: %s]"
                       (agy-review-entry-id entry)
                       (agy-review--entry-summary entry))))
    (overlay-put ov 'agy-review t)
    (overlay-put ov 'agy-review-id (agy-review-entry-id entry))
    (overlay-put ov 'help-echo (agy-review-entry-note entry))
    (overlay-put ov 'after-string
                 (propertize label 'face 'agy-review-annotation-face))
    ov))

(defun agy-review--sync-file-buffer (buf)
  "Sync inline `agy-review' overlays in file-visiting buffer BUF."
  (agy-review--clear-buffer-overlays buf)
  (when-let* ((buf-file (buffer-file-name buf)))
    (unless (zerop (hash-table-count agy-review--entries))
      (let ((abs-buf-file (expand-file-name buf-file)))
        (maphash
         (lambda (_root entries)
           (dolist (entry entries)
             (when (and (equal (agy-review-entry-abs-file entry) abs-buf-file)
                        (agy-review-entry-line entry)
                        (eq (agy-review-entry-side entry) 'new))
               (with-current-buffer buf
                 (save-excursion
                   (goto-char (point-min))
                   (when (zerop (forward-line (1- (agy-review-entry-line entry))))
                     (agy-review--place-overlay-at-point entry)))))))
         agy-review--entries)))))

(defun agy-review--walk-magit-sections (section fn)
  "Walk SECTION and its descendants, calling FN on each."
  (funcall fn section)
  (dolist (child (agy-review--slot section 'children))
    (agy-review--walk-magit-sections child fn)))

(defun agy-review--sync-magit-buffer (buf)
  "Sync `agy-review' overlays inside Magit buffer BUF."
  (agy-review--clear-buffer-overlays buf)
  (when (and (buffer-live-p buf)
             (not (zerop (hash-table-count agy-review--entries)))
             (fboundp 'magit-toplevel)
             (boundp 'magit-root-section))
    (with-current-buffer buf
      (when-let* ((toplevel (magit-toplevel))
                  (root (agy-review--canonical-dir toplevel))
                  (entries (agy-review--get-entries root))
                  (root-sec magit-root-section))
        (agy-review--walk-magit-sections
         root-sec
         (lambda (sec)
           (cond
            ((eq (agy-review--slot sec 'type) 'file)
             (let ((sec-file (agy-review--slot sec 'value)))
               (dolist (entry entries)
                 (when (and (null (agy-review-entry-line entry))
                            (equal (agy-review-entry-file entry) sec-file))
                   (save-excursion
                     (goto-char (agy-review--slot sec 'start))
                     (agy-review--place-overlay-at-point entry))))))
            ((eq (agy-review--slot sec 'type) 'hunk)
             (let* ((parent (agy-review--slot sec 'parent))
                    (sec-file (and parent (agy-review--slot parent 'value)))
                    (matching (cl-remove-if-not
                               (lambda (e)
                                 (and (agy-review-entry-line e)
                                      (equal (agy-review-entry-file e) sec-file)))
                               entries)))
               (when matching
                 (save-excursion
                   (goto-char (agy-review--slot sec 'content))
                   (let ((sec-end (agy-review--slot sec 'end)))
                     (while (< (point) sec-end)
                       (let* ((ch (char-after (line-beginning-position)))
                              (deleted (eq ch ?-))
                              (side (if deleted 'old 'new))
                              (hline (magit-diff-hunk-line sec deleted)))
                         (dolist (entry matching)
                           (when (and (eq (agy-review-entry-side entry) side)
                                      (eql (agy-review-entry-line entry) hline))
                             (agy-review--place-overlay-at-point entry))))
                       (forward-line 1))))))))))))))

(defun agy-review--list-buffer-name (root)
  "Return the review list buffer name for ROOT."
  (format "*agy-review:%s*" (agy-review--project-name root)))

(defun agy-review--sync-all-buffers (root)
  "Refresh overlays and any review list buffer for ROOT."
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (cond
       ((buffer-file-name buf)
        (when (string-prefix-p root (expand-file-name (buffer-file-name buf)))
          (agy-review--sync-file-buffer buf)))
       ((derived-mode-p 'magit-diff-mode 'magit-status-mode)
        (agy-review--sync-magit-buffer buf)))))
  (when-let* ((list-buf (get-buffer (agy-review--list-buffer-name root))))
    (when (buffer-live-p list-buf)
      (with-current-buffer list-buf
        (agy-review-list-refresh)))))

(defun agy-review--on-find-file ()
  "Hook for `find-file-hook' to display queued overlays."
  (unless (zerop (hash-table-count agy-review--entries))
    (agy-review--sync-file-buffer (current-buffer))))

(defun agy-review--on-magit-refresh ()
  "Hook for `magit-refresh-buffer-hook' to restore queued overlays."
  (unless (zerop (hash-table-count agy-review--entries))
    (when (derived-mode-p 'magit-diff-mode 'magit-status-mode)
      (agy-review--sync-magit-buffer (current-buffer)))))

(add-hook 'find-file-hook #'agy-review--on-find-file)
(add-hook 'magit-refresh-buffer-hook #'agy-review--on-magit-refresh)

;;; Multi-line Note Editor

(defvar-local agy-review--note-target nil)
(defvar-local agy-review--note-entry-id nil)
(defvar-local agy-review--note-window-config nil)

(defvar-keymap agy-review-note-mode-map
  :doc "Keymap for `agy-review-note-mode'."
  "C-c C-c" #'agy-review-note-commit
  "C-c C-k" #'agy-review-note-abort)

(define-derived-mode agy-review-note-mode text-mode "AGY-Note"
  "Major mode for writing or editing an `agy-review' comment.")

(defun agy-review--save-note-for-target (target note &optional entry-id)
  "Store NOTE for TARGET (updating ENTRY-ID when non-nil) and return entry."
  (let* ((root (plist-get target :root))
         (entries (agy-review--get-entries root))
         (entry nil))
    (if entry-id
        (progn
          (setq entry (agy-review--find-entry root entry-id))
          (unless entry
            (user-error "Review entry #%d no longer exists" entry-id))
          (setf (agy-review-entry-note entry) note))
      (setq entry (agy-review-entry-create
                   :id agy-review--next-id
                   :root root
                   :file (plist-get target :file)
                   :abs-file (plist-get target :abs-file)
                   :line (plist-get target :line)
                   :end-line (plist-get target :end-line)
                   :side (plist-get target :side)
                   :snippet (plist-get target :snippet)
                   :note note))
      (setq agy-review--next-id (1+ agy-review--next-id))
      (agy-review--set-entries root (append entries (list entry))))
    (agy-review--sync-all-buffers root)
    entry))

(defun agy-review-note-commit ()
  "Save the current note buffer and close it."
  (interactive)
  (let ((text (string-trim (buffer-string))))
    (when (string-empty-p text)
      (user-error "Empty review comment ignored (use C-c C-k to cancel)"))
    (let* ((target agy-review--note-target)
           (entry-id agy-review--note-entry-id)
           (win-cfg agy-review--note-window-config)
           (note-buf (current-buffer))
           (entry (agy-review--save-note-for-target target text entry-id)))
      (when (window-configuration-p win-cfg)
        (set-window-configuration win-cfg))
      (when (buffer-live-p note-buf)
        (kill-buffer note-buf))
      (message "Saved review comment #%d on %s"
               (agy-review-entry-id entry)
               (agy-review--format-location entry)))))

(defun agy-review-note-abort ()
  "Cancel editing the current review note and close its buffer."
  (interactive)
  (let ((win-cfg agy-review--note-window-config)
        (note-buf (current-buffer)))
    (when (window-configuration-p win-cfg)
      (set-window-configuration win-cfg))
    (when (buffer-live-p note-buf)
      (kill-buffer note-buf))
    (message "Cancelled review comment.")))

(defun agy-review--open-note-buffer (target &optional existing-entry)
  "Open the multi-line note editor for TARGET or EXISTING-ENTRY."
  (let ((win-cfg (current-window-configuration))
        (buf (get-buffer-create "*agy-review-note*"))
        (loc-entry (or existing-entry
                       (agy-review-entry-create
                        :file (plist-get target :file)
                        :line (plist-get target :line)
                        :end-line (plist-get target :end-line)
                        :side (plist-get target :side)))))
    (with-current-buffer buf
      (erase-buffer)
      (agy-review-note-mode)
      (setq agy-review--root (plist-get target :root)
            agy-review--note-target target
            agy-review--note-entry-id (and existing-entry
                                           (agy-review-entry-id existing-entry))
            agy-review--note-window-config win-cfg
            header-line-format
            (format " AGY Review: %s  [C-c C-c save | C-c C-k cancel]"
                    (agy-review--format-location loc-entry)))
      (when existing-entry
        (insert (agy-review-entry-note existing-entry))))
    (let ((win (display-buffer buf '((display-buffer-at-bottom)
                                     (window-height . 10)))))
      (when (window-live-p win)
        (select-window win)))
    buf))

;;;###autoload
(defun agy-review-annotate (&optional quick)
  "Add a review comment at point (in a file buffer or Magit diff).
With prefix argument QUICK, read a single-line note in the minibuffer
instead of opening the multi-line comment buffer."
  (interactive "P")
  (let ((target (agy-review--resolve-target)))
    (when (use-region-p)
      (deactivate-mark))
    (if quick
        (let ((note (string-trim (read-string "Review comment: "))))
          (when (string-empty-p note)
            (user-error "Empty review comment ignored"))
          (let ((entry (agy-review--save-note-for-target target note)))
            (message "Queued comment #%d on %s"
                     (agy-review-entry-id entry)
                     (agy-review--format-location entry))))
      (agy-review--open-note-buffer target))))

;;; Review List Buffer

(defun agy-review-list-next ()
  "Move point to the next review entry in the list buffer."
  (interactive)
  (let ((cur (get-text-property (point) 'agy-review-entry-id))
        (pos (point)))
    (while (and (< pos (point-max))
                (eql (get-text-property pos 'agy-review-entry-id) cur))
      (setq pos (next-single-property-change pos 'agy-review-entry-id nil (point-max))))
    (while (and (< pos (point-max))
                (null (get-text-property pos 'agy-review-entry-id)))
      (setq pos (next-single-property-change pos 'agy-review-entry-id nil (point-max))))
    (if (get-text-property pos 'agy-review-entry-id)
        (goto-char pos)
      (message "No next review comment"))))

(defun agy-review-list-prev ()
  "Move point to the previous review entry in the list buffer."
  (interactive)
  (let ((cur (get-text-property (point) 'agy-review-entry-id))
        (pos (point)))
    (while (and (> pos (point-min))
                (eql (get-text-property pos 'agy-review-entry-id) cur))
      (setq pos (previous-single-property-change pos 'agy-review-entry-id nil (point-min))))
    (while (and (> pos (point-min))
                (null (get-text-property pos 'agy-review-entry-id)))
      (setq pos (previous-single-property-change pos 'agy-review-entry-id nil (point-min))))
    (when (> pos (point-min))
      (let ((id (get-text-property (1- pos) 'agy-review-entry-id)))
        (when id
          (setq pos (1- pos))
          (while (and (> pos (point-min))
                      (eql (get-text-property (1- pos) 'agy-review-entry-id) id))
            (setq pos (1- pos))))))
    (if (get-text-property pos 'agy-review-entry-id)
        (goto-char pos)
      (message "No previous review comment"))))

(defun agy-review--list-entry-at-point ()
  "Return the `agy-review-entry' at point in the review list buffer."
  (let ((id (get-text-property (point) 'agy-review-entry-id)))
    (unless id
      (user-error "No review comment at point"))
    (or (agy-review--find-entry (agy-review--project-root) id)
        (user-error "Review comment #%d no longer exists" id))))

(defun agy-review-list-jump ()
  "Jump to the source file and line for the review entry at point."
  (interactive)
  (let* ((entry (agy-review--list-entry-at-point))
         (abs-file (agy-review-entry-abs-file entry))
         (line (agy-review-entry-line entry)))
    (unless (file-exists-p abs-file)
      (user-error "File does not exist: %s" abs-file))
    (find-file-other-window abs-file)
    (when line
      (goto-char (point-min))
      (forward-line (1- line)))))

(defun agy-review-list-edit ()
  "Edit the review comment at point in the multi-line note editor."
  (interactive)
  (let* ((entry (agy-review--list-entry-at-point))
         (target (list :root (agy-review-entry-root entry)
                       :file (agy-review-entry-file entry)
                       :abs-file (agy-review-entry-abs-file entry)
                       :line (agy-review-entry-line entry)
                       :end-line (agy-review-entry-end-line entry)
                       :side (agy-review-entry-side entry)
                       :snippet (agy-review-entry-snippet entry))))
    (agy-review--open-note-buffer target entry)))

(defun agy-review-list-delete ()
  "Delete the review comment at point."
  (interactive)
  (let* ((root (agy-review--project-root))
         (entry (agy-review--list-entry-at-point))
         (id (agy-review-entry-id entry))
         (remaining (cl-remove-if (lambda (e) (eql (agy-review-entry-id e) id))
                                  (agy-review--get-entries root))))
    (agy-review--set-entries root remaining)
    (agy-review--sync-all-buffers root)
    (message "Deleted review comment #%d" id)))

(defun agy-review-list-flush-and-submit ()
  "Flush queued comments to ghostel and submit immediately."
  (interactive)
  (let ((agy-review-auto-submit t))
    (agy-review-flush)))

(defun agy-review-list-refresh ()
  "Re-render the contents of the current `agy-review-list-mode' buffer."
  (interactive)
  (when (derived-mode-p 'agy-review-list-mode)
    (let* ((root (agy-review--project-root))
           (entries (agy-review--get-entries root))
           (inhibit-read-only t)
           (saved-line (line-number-at-pos)))
      (erase-buffer)
      (insert (format "AGY Review Queue — %s (%d comment%s)\n"
                      (agy-review--project-name root)
                      (length entries)
                      (if (= (length entries) 1) "" "s")))
      (insert "Keys: [RET] jump  [e] edit  [d] delete  [f] flush  [F] flush+submit  [C] clear  [g] refresh\n\n")
      (if (null entries)
          (insert "(No queued review comments)\n")
        (dolist (entry entries)
          (let ((start (point)))
            (insert (propertize (format "#%d %s\n"
                                        (agy-review-entry-id entry)
                                        (agy-review--format-location entry))
                                'face 'agy-review-list-location-face))
            (dolist (nline (split-string (agy-review-entry-note entry) "\n"))
              (insert "  " nline "\n"))
            (when-let* ((snip (agy-review-entry-snippet entry)))
              (unless (string-empty-p snip)
                (dolist (sline (split-string snip "\n"))
                  (insert (propertize (concat "    | " sline "\n")
                                      'face 'agy-review-list-snippet-face)))))
            (insert "\n")
            (add-text-properties start (point)
                                 (list 'agy-review-entry-id (agy-review-entry-id entry))))))
      (goto-char (point-min))
      (forward-line (1- saved-line)))))

(defvar-keymap agy-review-list-mode-map
  :doc "Keymap for `agy-review-list-mode'."
  "n" #'agy-review-list-next
  "TAB" #'agy-review-list-next
  "p" #'agy-review-list-prev
  "<backtab>" #'agy-review-list-prev
  "RET" #'agy-review-list-jump
  "o" #'agy-review-list-jump
  "e" #'agy-review-list-edit
  "d" #'agy-review-list-delete
  "k" #'agy-review-list-delete
  "f" #'agy-review-flush
  "F" #'agy-review-list-flush-and-submit
  "C" #'agy-review-clear
  "g" #'agy-review-list-refresh)

(define-derived-mode agy-review-list-mode special-mode "AGY-Review"
  "Major mode for inspecting and managing queued `agy-review' comments.")

;;;###autoload
(defun agy-review-list ()
  "Open the review comment list buffer for the current project."
  (interactive)
  (let* ((root (agy-review--project-root))
         (buf (get-buffer-create (agy-review--list-buffer-name root))))
    (with-current-buffer buf
      (agy-review-list-mode)
      (setq agy-review--root root)
      (agy-review-list-refresh))
    (pop-to-buffer buf)
    buf))

;;; Formatting, Clearing & Flushing

(defun agy-review--format-entries (entries)
  "Format ENTRIES into a structured prompt string for `agy'."
  (let ((idx 0))
    (concat
     agy-review-prompt-header
     "\n\n"
     (mapconcat
      (lambda (entry)
        (setq idx (1+ idx))
        (let* ((loc (agy-review--format-location entry))
               (note-lines (split-string (agy-review-entry-note entry) "\n"))
               (note-text (mapconcat #'identity note-lines "\n   "))
               (snip (agy-review-entry-snippet entry)))
          (concat
           (format "%d. `%s`: %s" idx loc note-text)
           (when (and snip (not (string-empty-p snip)))
             (format "\n```\n%s\n```" snip)))))
      entries
      "\n\n"))))

;;;###autoload
(defun agy-review-clear (&optional no-confirm)
  "Remove all queued review comments for the current project.
Unless NO-CONFIRM is non-nil, prompt before discarding comments."
  (interactive)
  (let* ((root (agy-review--project-root))
         (entries (agy-review--get-entries root)))
    (when (and entries
               (not no-confirm)
               (called-interactively-p 'any)
               (not (yes-or-no-p
                     (format "Clear %d queued review comment(s) for %s? "
                             (length entries)
                             (agy-review--project-name root)))))
      (user-error "Aborted"))
    (agy-review--set-entries root nil)
    (agy-review--sync-all-buffers root)
    (message "Cleared agy review annotations for %s."
             (agy-review--project-name root))))

;;;###autoload
(defun agy-review-flush (&optional arg)
  "Paste queued comments for the current project into its agy ghostel buffer.
With prefix argument ARG, toggle `agy-review-auto-submit'."
  (interactive "P")
  (let* ((root (agy-review--project-root))
         (entries (agy-review--get-entries root)))
    (unless entries
      (user-error "No queued review comments for %s"
                  (agy-review--project-name root)))
    (let ((buf (gethash root agy-review--buffers)))
      (unless (agy-review--ghostel-live-p buf)
        (let ((live (agy-review--live-ghostel-buffers)))
          (if live
              (setq buf (agy-review-attach))
            (user-error "No live agy ghostel buffer for %s. Start one with `agy-review-start'"
                        (agy-review--project-name root)))))
      (let ((submit (if arg (not agy-review-auto-submit) agy-review-auto-submit))
            (payload (agy-review--format-entries entries))
            (count (length entries)))
        (agy-review--send-to-ghostel buf payload submit)
        (agy-review-clear t)
        (pop-to-buffer buf)
        (message "Sent %d review comment(s) to %s." count (buffer-name buf))))))

;;; Command Map

;;;###autoload
(defvar-keymap agy-review-command-map
  :doc "Prefix keymap for `agy-review' commands."
  "s" #'agy-review-start
  "b" #'agy-review-attach
  "a" #'agy-review-annotate
  "l" #'agy-review-list
  "f" #'agy-review-flush
  "c" #'agy-review-clear)

(provide 'agy-review)
;;; agy-review.el ends here
