;;; srikkant-annotate.el --- Global line annotator & review scratchpad for Emacs -*- lexical-binding: t; -*-

;; Author: Srikkant
;; Keywords: git, tools, magit, diff, review, notes, annotation, org

;;; Commentary:
;; This package provides a fast, scratchpad-like review workflow and global line annotator.
;; Users can annotate lines in Magit diffs, source code files, or any text buffer.
;;
;; Key concepts:
;; - Annotations in memory are draft annotations (a scratchpad).
;; - Add/edit/DWIM draft notes at point on any line (in diffs or any file buffer) with `/` or `C-x C-/`.
;; - Pressing `=` (or `w`) writes/flushes draft annotations to an Org-mode `.notes` file in the
;;   project/Git root and clears the memory buffer.
;; - Visual overlays in both Magit diff buffers and file buffers show inline note badges and previews.
;; - Full in-memory CRUD operations (Create, Read, Update, Delete, Clear, Load from disk).
;; - Global keybinding prefix `C-x C-/` triggers the transient menu or command map everywhere.
;; - Quick jump to any note (`j` / `C-x C-/ j`) with `completing-read`.
;; - Next / Previous navigation between notes in any buffer (`]` / `[`).

;;; Code:

(require 'cl-lib)
(require 'subr-x)
(require 'project nil t)
(require 'transient)
(require 'magit nil t)
(require 'magit-diff nil t)

(declare-function dired-get-filename "dired" (&optional localp no-error-if-not-filep))
(declare-function magit-toplevel "magit-git" (&optional directory))
(declare-function magit-diff-visit-file--noselect "magit-diff" (&optional other-window))
(declare-function magit-current-section "magit-section" ())
(declare-function magit-collect-sections "magit-section" (type &optional root))

(defgroup srikkant-annotate nil
  "Global line annotator & review scratchpad."
  :group 'tools)

(defface srikkant-annotate-badge-face
  '((((class color) (background dark))
     :foreground "#b58900" :weight bold)
    (((class color) (background light))
     :foreground "#b58900" :weight bold)
    (t :weight bold))
  "Face for the note icon badge in overlays."
  :group 'srikkant-annotate)

(defface srikkant-annotate-overlay-face
  '((((class color) (background dark))
     :foreground "#93a1a1" :slant italic)
    (((class color) (background light))
     :foreground "#586e75" :slant italic)
    (t :slant italic))
  "Face for the inline note text preview in overlays."
  :group 'srikkant-annotate)

(defcustom srikkant-annotate-filename ".notes"
  "Name of the Org-mode notes file stored in the project or Git root."
  :type 'string
  :group 'srikkant-annotate)

(defcustom srikkant-annotate-show-inline-preview t
  "Whether to show a short note preview inline at the end of the line."
  :type 'boolean
  :group 'srikkant-annotate)

(defcustom srikkant-annotate-preview-max-length 40
  "Maximum character length of the inline note preview."
  :type 'integer
  :group 'srikkant-annotate)

;;; Project & Session Storage

(defvar srikkant-annotate--session-notes (make-hash-table :test 'equal)
  "Hash table mapping project root paths to lists of in-memory draft note plists.")

(defun srikkant-annotate--project-root (&optional dir)
  "Return project root directory for DIR (defaults to `default-directory`)."
  (let* ((dir (expand-file-name (or dir default-directory)))
         (default-directory (file-name-as-directory dir))
         (top (or (and (fboundp 'magit-toplevel) (magit-toplevel))
                  (and (fboundp 'project-current) (project-current)
                       (let ((pr (project-current)))
                         (if (fboundp 'project-root)
                             (project-root pr)
                           (with-no-warnings (car (project-roots pr))))))
                  default-directory)))
    (file-name-as-directory (expand-file-name top))))

(defun srikkant-annotate--file-path (&optional root)
  "Return absolute path to the notes file for ROOT (defaults to project root)."
  (let ((top (srikkant-annotate--project-root root)))
    (expand-file-name srikkant-annotate-filename top)))

(defun srikkant-annotate--get-session-notes (&optional root)
  "Get the list of in-memory draft review notes for ROOT."
  (let ((top (srikkant-annotate--project-root root)))
    (gethash top srikkant-annotate--session-notes nil)))

(defun srikkant-annotate--set-session-notes (notes &optional root)
  "Set the list of in-memory draft review NOTES for ROOT."
  (let ((top (srikkant-annotate--project-root root)))
    (puthash top notes srikkant-annotate--session-notes)))

(defun srikkant-annotate--generate-id ()
  "Generate a unique note ID."
  (format "note-%s-%03d"
          (format-time-string "%Y%m%d-%H%M%S")
          (random 1000)))

;;; Note Serialization & Parsing (Org-Mode Format)

(defun srikkant-annotate--format-note (note)
  "Format a NOTE plist into an Org-mode entry string."
  (let ((id (plist-get note :id))
        (file (plist-get note :file))
        (line (plist-get note :line))
        (context (plist-get note :context))
        (date (plist-get note :date))
        (body (plist-get note :body)))
    (format "* [[file:%s::%s][%s:%s]]\n:PROPERTIES:\n:ID: %s\n:DATE: %s%s\n:END:\n\n%s\n\n"
            file line file line
            id date
            (if (and context (not (string-empty-p context)))
                (format "\n:CONTEXT: %s" (string-trim context))
              "")
            body)))

(defun srikkant-annotate--parse-file (&optional notes-file)
  "Parse NOTES-FILE (Org-mode format) into a list of note plists."
  (let ((file (or notes-file (srikkant-annotate--file-path))))
    (if (not (file-exists-p file))
        nil
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (let (notes)
          ;; Match Org headings: `* [[file:FILE::LINE][...]]` or `* FILE:LINE`
          (while (re-search-forward "^\\* +\\(?:\\[\\[file:\\([^:]+\\)::\\([0-9]+\\)\\]\\[.*?\\]\\]\\|\\([^:\n]+\\):\\([0-9]+\\)\\)" nil t)
            (let* ((rel-file (or (match-string 1) (match-string 3)))
                   (line (string-to-number (or (match-string 2) (match-string 4))))
                   (header-end (line-end-position))
                   (section-end (save-excursion
                                  (if (re-search-forward "^\\* " nil t)
                                      (match-beginning 0)
                                    (point-max))))
                   (section-str (buffer-substring-no-properties header-end section-end))
                   (id (when (string-match ":ID: +\\([^\n]+\\)" section-str)
                         (string-trim (match-string 1 section-str))))
                   (date (when (string-match ":DATE: +\\([^\n]+\\)" section-str)
                           (string-trim (match-string 1 section-str))))
                   (context (when (string-match ":CONTEXT: +\\([^\n]+\\)" section-str)
                              (string-trim (match-string 1 section-str))))
                   (body (with-temp-buffer
                           (insert section-str)
                           (goto-char (point-min))
                           (while (re-search-forward ":PROPERTIES:[ \t]*\n\\(?:.*\n\\)*?[ \t]*:END:[ \t]*\n?" nil t)
                             (replace-match ""))
                           (string-trim (buffer-string)))))
              (push (list :id (or id (srikkant-annotate--generate-id))
                          :file rel-file
                          :line line
                          :context (or context "")
                          :date (or date (format-time-string "%Y-%m-%d %H:%M:%S"))
                          :body (or body ""))
                    notes)
              (goto-char section-end)))
          ;; Legacy Markdown fallback (### `file:line`)
          (when (null notes)
            (goto-char (point-min))
            (while (re-search-forward "^### `\\([^:]+\\):\\([0-9]+\\)`" nil t)
              (let* ((rel-file (match-string 1))
                     (line (string-to-number (match-string 2)))
                     (header-end (point))
                     (section-end (if (re-search-forward "^---" nil t)
                                      (match-beginning 0)
                                    (point-max)))
                     (section-str (buffer-substring-no-properties header-end section-end))
                     (id (when (string-match "- \\*\\*ID:\\*\\* `\\([^`]+\\)`" section-str)
                           (match-string 1 section-str)))
                     (date (when (string-match "- \\*\\*Date:\\*\\* \\([^\n]+\\)" section-str)
                             (match-string 1 section-str)))
                     (context (when (string-match "- \\*\\*Context:\\*\\* `\\([^`]+\\)`" section-str)
                                (match-string 1 section-str)))
                     (body (with-temp-buffer
                             (insert section-str)
                             (goto-char (point-min))
                             (flush-lines "^- \\*\\*")
                             (string-trim (buffer-string)))))
                (push (list :id (or id (srikkant-annotate--generate-id))
                            :file rel-file
                            :line line
                            :context (or context "")
                            :date (or date (format-time-string "%Y-%m-%d %H:%M:%S"))
                            :body (or body ""))
                      notes)
                (goto-char section-end))))
          (nreverse notes))))))

(defun srikkant-annotate--write-file (notes &optional notes-file)
  "Write list of NOTES plists to NOTES-FILE in Org-mode format.
If NOTES-FILE exists, appends NOTES to it.
Otherwise, creates NOTES-FILE with Org header and inserts NOTES."
  (let ((file (or notes-file (srikkant-annotate--file-path))))
    (if (file-exists-p file)
        (with-temp-buffer
          (insert-file-contents file)
          (goto-char (point-max))
          (unless (bolp) (insert "\n"))
          (dolist (note notes)
            (insert (srikkant-annotate--format-note note)))
          (write-region (point-min) (point-max) file nil 'quiet))
      (with-temp-file file
        (insert "#+TITLE: Annotations & Code Review Notes\n")
        (insert (format "#+DATE: %s\n\n" (format-time-string "%Y-%m-%d")))
        (dolist (note notes)
          (insert (srikkant-annotate--format-note note)))))))

;;; Location Resolution (Diff & Global File Buffers)

(defun srikkant-annotate--point-location ()
  "Get target file, line number, and line content at point.
Works in Magit diff buffers, regular file buffers, and Dired.
Returns a plist `(:file REL-PATH :line LINE-NUM :context LINE-CONTENT)' or nil."
  (let ((top (srikkant-annotate--project-root)))
    (or
     ;; 1. Inside Magit diff buffer hunk
     (condition-case nil
         (pcase-let* ((`(,buf ,pos) (and (fboundp 'magit-diff-visit-file--noselect)
                                         (magit-diff-visit-file--noselect t))))
           (when (and buf pos)
             (with-current-buffer buf
               (save-excursion
                 (save-restriction
                   (widen)
                   (goto-char pos)
                   (let ((file-name (buffer-file-name)))
                     (when file-name
                       (list :file (if top (file-relative-name file-name top) file-name)
                             :line (line-number-at-pos pos)
                             :context (string-trim (thing-at-point 'line t))))))))))
       (error nil))
     ;; 2. Inside regular file-visiting buffer
     (when-let* ((file-name (buffer-file-name)))
       (list :file (if top (file-relative-name file-name top) file-name)
             :line (line-number-at-pos (point))
             :context (string-trim (thing-at-point 'line t))))
     ;; 3. Inside Dired buffer
     (when (derived-mode-p 'dired-mode)
       (when-let* ((dired-file (dired-get-filename nil t)))
         (list :file (if top (file-relative-name dired-file top) dired-file)
               :line 1
               :context (file-name-nondirectory dired-file)))))))

(defun srikkant-annotate--notes-at-point ()
  "Get all in-memory draft notes matching the current line at point."
  (when-let* ((loc (srikkant-annotate--point-location))
              (file (plist-get loc :file))
              (line (plist-get loc :line))
              (notes (srikkant-annotate--get-session-notes)))
    (cl-remove-if-not
     (lambda (n)
       (and (string= (plist-get n :file) file)
            (= (plist-get n :line) line)))
     notes)))

;;; Visual Overlays (Diffs & File Buffers)

(defun srikkant-annotate--clear-overlays (&optional buffer)
  "Clear all review note overlays in BUFFER (defaults to current buffer)."
  (with-current-buffer (or buffer (current-buffer))
    (remove-overlays (point-min) (point-max) 'srikkant-annotate t)))

(defun srikkant-annotate--hunk-file (hunk-section)
  "Get relative file path for HUNK-SECTION."
  (let ((parent (and (slot-boundp hunk-section 'parent) (oref hunk-section parent))))
    (while (and parent (not (eq (oref parent type) 'file)))
      (setq parent (and (slot-boundp parent 'parent) (oref parent parent))))
    (when parent
      (let ((val (oref parent value))
            (top (srikkant-annotate--project-root)))
        (if (and top val (file-name-absolute-p val))
            (file-relative-name val top)
          val)))))

(defun srikkant-annotate--hunk-lines-mapping (hunk-section)
  "Return an alist of ((FILE . LINE-NUMBER) . BUFFER-POS) in HUNK-SECTION."
  (let ((file (srikkant-annotate--hunk-file hunk-section)))
    (when file
      (with-slots (content end to-range from-range) hunk-section
        (when (and content end to-range)
          (let ((to-line (car to-range))
                (mapping nil))
            (save-excursion
              (goto-char content)
              (while (< (point) end)
                (let ((ch (char-after))
                      (pos (point)))
                  (cond
                   ((eq ch ?+)
                    (push (cons (cons file to-line) pos) mapping)
                    (setq to-line (1+ to-line)))
                   ((eq ch ?\s)
                    (push (cons (cons file to-line) pos) mapping)
                    (setq to-line (1+ to-line)))
                   ((eq ch ?-)
                    nil))
                  (forward-line 1))))
            (nreverse mapping)))))))

(defun srikkant-annotate--create-overlay (pos matched-notes)
  "Create a note overlay at POS displaying MATCHED-NOTES."
  (let* ((ov (make-overlay pos pos))
         (count (length matched-notes))
         (first-body (plist-get (car (last matched-notes)) :body))
         (body-preview (if (> (length first-body) srikkant-annotate-preview-max-length)
                           (concat (substring first-body 0 srikkant-annotate-preview-max-length) "…")
                         first-body))
         (badge (propertize (if (> count 1)
                                (format " 📝[%d notes] " count)
                              " 📝 ")
                            'face 'srikkant-annotate-badge-face))
         (preview-str (if srikkant-annotate-show-inline-preview
                          (propertize (format "\"%s\"" body-preview)
                                      'face 'srikkant-annotate-overlay-face)
                        ""))
         (tooltip (mapconcat
                   (lambda (n)
                     (format "[%s] %s:%s (%s):\n%s"
                             (plist-get n :id)
                             (plist-get n :file)
                             (plist-get n :line)
                             (plist-get n :date)
                             (plist-get n :body)))
                   (reverse matched-notes)
                   "\n\n---\n\n")))
    (overlay-put ov 'srikkant-annotate t)
    (overlay-put ov 'srikkant-annotate-data matched-notes)
    (overlay-put ov 'after-string
                 (propertize (concat badge preview-str)
                             'help-echo tooltip))))

(defun srikkant-annotate--refresh-buffer-overlays (&optional buffer)
  "Refresh review note overlays in BUFFER (defaults to current buffer)."
  (with-current-buffer (or buffer (current-buffer))
    (srikkant-annotate--clear-overlays)
    (let ((top (srikkant-annotate--project-root)))
      (cond
       ;; A. Magit diff / status buffer
       ((derived-mode-p 'magit-diff-mode 'magit-status-mode)
        (when-let* ((notes (srikkant-annotate--get-session-notes top)))
          (save-excursion
            (let ((notes-table (make-hash-table :test 'equal)))
              (dolist (n notes)
                (let ((key (cons (plist-get n :file) (plist-get n :line))))
                  (puthash key (cons n (gethash key notes-table nil)) notes-table)))
              (when (fboundp 'magit-collect-sections)
                (dolist (hunk (magit-collect-sections 'hunk (magit-current-section)))
                  (let ((mapping (srikkant-annotate--hunk-lines-mapping hunk)))
                    (dolist (item mapping)
                      (let* ((key (car item))
                             (pos (cdr item))
                             (matched-notes (gethash key notes-table)))
                        (when matched-notes
                          (goto-char pos)
                          (srikkant-annotate--create-overlay (line-end-position) matched-notes)))))))))))
       ;; B. Regular file-visiting buffer
       ((buffer-file-name)
        (when-let* ((notes (srikkant-annotate--get-session-notes top))
                    (rel-file (file-relative-name (buffer-file-name) top)))
          (let ((file-notes (cl-remove-if-not
                             (lambda (n) (string= (plist-get n :file) rel-file))
                             notes)))
            (when file-notes
              (save-excursion
                (save-restriction
                  (widen)
                  (let ((line-table (make-hash-table :test 'eql)))
                    (dolist (n file-notes)
                      (let ((line (plist-get n :line)))
                        (puthash line (cons n (gethash line line-table nil)) line-table)))
                    (maphash
                     (lambda (line matched-notes)
                       (goto-char (point-min))
                       (when (zerop (forward-line (1- line)))
                         (srikkant-annotate--create-overlay (line-end-position) matched-notes)))
                     line-table))))))))))))

;;;###autoload
(defun srikkant-annotate-refresh-overlays ()
  "Refresh review note overlays across all live buffers."
  (interactive)
  (dolist (buf (buffer-list))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (when (or (derived-mode-p 'magit-diff-mode 'magit-status-mode)
                  (buffer-file-name))
          (srikkant-annotate--refresh-buffer-overlays buf))))))

;;; Interactive CRUD Commands

;;;###autoload
(defun srikkant-annotate-dwim ()
  "Add, edit, or view in-memory review note at point on current line.
Works in Magit diff buffers and any file buffer.
If no note exists on this line, prompts to add a new note.
If notes exist on this line, prompts whether to edit, add another, or delete."
  (interactive)
  (let* ((loc (srikkant-annotate--point-location)))
    (unless loc
      (user-error "No valid file or line detected at point"))
    (let* ((file (plist-get loc :file))
           (line (plist-get loc :line))
           (existing-notes (srikkant-annotate--notes-at-point)))
      (if existing-notes
          (let* ((choice (read-char-choice
                          (format "Note exists on %s:%d - [e]dit, [a]dd another, [d]elete, [v]iew: " file line)
                          '(?e ?a ?d ?v ?\C-g))))
            (pcase choice
              (?e (srikkant-annotate-edit-at-point))
              (?a (srikkant-annotate-add-at-point loc))
              (?d (srikkant-annotate-delete-at-point))
              (?v (srikkant-annotate-open-file))))
        (srikkant-annotate-add-at-point loc)))))

;;;###autoload
(defun srikkant-annotate-add-at-point (&optional loc)
  "Add a new review note for LOC (or line at point) in draft session memory."
  (interactive)
  (let* ((location (or loc (srikkant-annotate--point-location))))
    (unless location
      (user-error "No valid file or line detected at point"))
    (let* ((top (srikkant-annotate--project-root))
           (file (plist-get location :file))
           (line (plist-get location :line))
           (context (plist-get location :context))
           (note-text (read-string (format "Annotation [%s:%d]: " file line))))
      (if (string-empty-p (string-trim note-text))
          (message "Aborted: Empty note.")
        (let* ((all-notes (srikkant-annotate--get-session-notes top))
               (new-note (list :id (srikkant-annotate--generate-id)
                               :file file
                               :line line
                               :context context
                               :date (format-time-string "%Y-%m-%d %H:%M:%S")
                               :body (string-trim note-text))))
          (setq all-notes (append all-notes (list new-note)))
          (srikkant-annotate--set-session-notes all-notes top)
          (srikkant-annotate-refresh-overlays)
          (message "Added draft note for %s:%d (press '=' or 'C-x C-/ =' to flush to %s)"
                   file line srikkant-annotate-filename))))))

;;;###autoload
(defun srikkant-annotate-edit-at-point ()
  "Edit the existing review note on the current line in draft session memory."
  (interactive)
  (let ((notes (srikkant-annotate--notes-at-point)))
    (unless notes
      (user-error "No note at point to edit"))
    (let* ((top (srikkant-annotate--project-root))
           (target-note (if (= (length notes) 1)
                            (car notes)
                          (let* ((candidates (mapcar (lambda (n)
                                                       (cons (format "[%s] %s"
                                                                     (plist-get n :id)
                                                                     (plist-get n :body))
                                                             n))
                                                     notes))
                                 (selected (completing-read "Select note to edit: " candidates nil t)))
                            (cdr (assoc selected candidates)))))
           (old-body (plist-get target-note :body))
           (new-body (read-string "Edit Note: " old-body)))
      (if (string-empty-p (string-trim new-body))
          (message "Note unchanged.")
        (let* ((all-notes (srikkant-annotate--get-session-notes top))
               (id (plist-get target-note :id))
               (updated-notes
                (mapcar (lambda (n)
                          (if (string= (plist-get n :id) id)
                              (plist-put (copy-sequence n) :body (string-trim new-body))
                            n))
                        all-notes)))
          (srikkant-annotate--set-session-notes updated-notes top)
          (srikkant-annotate-refresh-overlays)
          (message "Updated draft note %s (press '=' to flush)" id))))))

;;;###autoload
(defun srikkant-annotate-delete-at-point ()
  "Delete review note(s) at point from draft session memory."
  (interactive)
  (let ((notes (srikkant-annotate--notes-at-point)))
    (unless notes
      (user-error "No note at point to delete"))
    (let* ((top (srikkant-annotate--project-root))
           (target-id (if (= (length notes) 1)
                          (plist-get (car notes) :id)
                        (let* ((candidates (mapcar (lambda (n)
                                                     (cons (format "[%s] %s"
                                                                   (plist-get n :id)
                                                                   (plist-get n :body))
                                                           (plist-get n :id)))
                                                   notes))
                               (selected (completing-read "Select note to delete: " candidates nil t)))
                          (cdr (assoc selected candidates)))))
           (all-notes (srikkant-annotate--get-session-notes top))
           (remaining (cl-remove-if (lambda (n) (string= (plist-get n :id) target-id)) all-notes)))
      (when (y-or-n-p (format "Delete draft note [%s]? " target-id))
        (srikkant-annotate--set-session-notes remaining top)
        (srikkant-annotate-refresh-overlays)
        (message "Deleted draft note %s" target-id)))))

;;;###autoload
(defun srikkant-annotate-save ()
  "Write all in-memory draft review notes to `.notes` and clear memory."
  (interactive)
  (let* ((top (srikkant-annotate--project-root))
         (notes (srikkant-annotate--get-session-notes top))
         (file (srikkant-annotate--file-path top)))
    (if (null notes)
        (message "No draft review notes in memory to flush.")
      (srikkant-annotate--write-file notes file)
      (let ((count (length notes)))
        (srikkant-annotate--set-session-notes nil top)
        (srikkant-annotate-refresh-overlays)
        (message "Flushed %d draft review note%s to %s (memory buffer cleared)"
                 count
                 (if (= count 1) "" "s")
                 file)))))

;;;###autoload
(defun srikkant-annotate-jump ()
  "Prompt to select a note and jump to its file and line.
Searches draft session notes first; if empty, offers saved notes from disk."
  (interactive)
  (let* ((top (srikkant-annotate--project-root))
         (session-notes (srikkant-annotate--get-session-notes top))
         (disk-notes (unless session-notes
                       (srikkant-annotate--parse-file (srikkant-annotate--file-path top))))
         (notes (or session-notes disk-notes))
         (is-draft (not (null session-notes))))
    (unless notes
      (user-error "No review notes found (draft memory is empty and no %s file exists)"
                  srikkant-annotate-filename))
    (let* ((candidates
            (mapcar (lambda (n)
                      (let* ((file (plist-get n :file))
                             (line (plist-get n :line))
                             (body (plist-get n :body))
                             (date (plist-get n :date))
                             (tag (if is-draft "[draft]" "[saved]"))
                             (formatted (format "%-7s %-28s %-40s (%s)"
                                                tag
                                                (format "%s:%d" file line)
                                                (if (> (length body) 38)
                                                    (concat (substring body 0 38) "…")
                                                  body)
                                                date)))
                        (cons formatted n)))
                    notes))
           (choice (completing-read (if is-draft
                                        "Jump to draft note: "
                                      "Jump to saved note: ")
                                    candidates nil t))
           (selected-note (cdr (assoc choice candidates))))
      (when selected-note
        (let* ((abs-file (expand-file-name (plist-get selected-note :file) top))
               (target-line (plist-get selected-note :line)))
          (if (file-exists-p abs-file)
              (progn
                (find-file abs-file)
                (goto-char (point-min))
                (forward-line (1- target-line))
                (recenter))
            (user-error "File does not exist: %s" abs-file)))))))

;;;###autoload
(defun srikkant-annotate-open-file ()
  "Open the `.notes` file for the current project in Org mode."
  (interactive)
  (let ((file (srikkant-annotate--file-path)))
    (if (file-exists-p file)
        (progn
          (find-file file)
          (unless (derived-mode-p 'org-mode)
            (org-mode)))
      (user-error "No %s file exists yet on disk (press '=' or 'C-x C-/ =' to flush draft notes)"
                  srikkant-annotate-filename))))

;;;###autoload
(defun srikkant-annotate-load-from-file (&optional notes-file)
  "Load notes from NOTES-FILE (defaults to `.notes`) into the active draft memory."
  (interactive)
  (let* ((top (srikkant-annotate--project-root))
         (file (or notes-file (srikkant-annotate--file-path top))))
    (if (not (file-exists-p file))
        (user-error "No %s file found to load" file)
      (let ((disk-notes (srikkant-annotate--parse-file file)))
        (srikkant-annotate--set-session-notes disk-notes top)
        (srikkant-annotate-refresh-overlays)
        (message "Loaded %d note%s from %s into draft memory"
                 (length disk-notes)
                 (if (= (length disk-notes) 1) "" "s")
                 file)))))

;;;###autoload
(defun srikkant-annotate-next ()
  "Move point to the next note overlay in the current buffer."
  (interactive)
  (let* ((current-pos (point))
         (overlays (cl-remove-if-not
                    (lambda (ov) (overlay-get ov 'srikkant-annotate))
                    (overlays-in (point-min) (point-max))))
         (next-ov (cl-find-if (lambda (ov) (> (overlay-start ov) current-pos))
                              (cl-sort overlays #'< :key #'overlay-start))))
    (if next-ov
        (progn
          (goto-char (overlay-start next-ov))
          (beginning-of-line))
      (message "No following notes in buffer."))))

;;;###autoload
(defun srikkant-annotate-prev ()
  "Move point to the previous note overlay in the current buffer."
  (interactive)
  (let* ((overlays (cl-remove-if-not
                    (lambda (ov) (overlay-get ov 'srikkant-annotate))
                    (overlays-in (point-min) (point-max))))
         (prev-ov (cl-find-if (lambda (ov) (< (overlay-start ov) (line-beginning-position)))
                              (cl-sort overlays #'> :key #'overlay-start))))
    (if prev-ov
        (progn
          (goto-char (overlay-start prev-ov))
          (beginning-of-line))
      (message "No preceding notes in buffer."))))

;;;###autoload
(defun srikkant-annotate-clear-all ()
  "Clear all draft review notes from session memory after confirmation."
  (interactive)
  (when (yes-or-no-p "Clear all in-memory draft review notes? ")
    (let ((top (srikkant-annotate--project-root)))
      (srikkant-annotate--set-session-notes nil top)
      (srikkant-annotate-refresh-overlays)
      (message "Cleared draft review notes from memory."))))

;;; Keymap & Transient Menu

(defvar srikkant-annotate-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "/") #'srikkant-annotate-dwim)
    (define-key map (kbd "C-/") #'srikkant-annotate-dwim)
    (define-key map (kbd "n") #'srikkant-annotate-dwim)
    (define-key map (kbd "a") #'srikkant-annotate-add-at-point)
    (define-key map (kbd "e") #'srikkant-annotate-edit-at-point)
    (define-key map (kbd "d") #'srikkant-annotate-delete-at-point)
    (define-key map (kbd "k") #'srikkant-annotate-delete-at-point)
    (define-key map (kbd "=") #'srikkant-annotate-save)
    (define-key map (kbd "w") #'srikkant-annotate-save)
    (define-key map (kbd "j") #'srikkant-annotate-jump)
    (define-key map (kbd "v") #'srikkant-annotate-open-file)
    (define-key map (kbd "l") #'srikkant-annotate-load-from-file)
    (define-key map (kbd "]") #'srikkant-annotate-next)
    (define-key map (kbd "[") #'srikkant-annotate-prev)
    (define-key map (kbd "g") #'srikkant-annotate-refresh-overlays)
    (define-key map (kbd "K") #'srikkant-annotate-clear-all)
    (define-key map (kbd "?") #'srikkant-annotate-menu)
    (define-key map (kbd "m") #'srikkant-annotate-menu)
    map)
  "Keymap for `srikkant-annotate' commands.")
(fset 'srikkant-annotate-command-map srikkant-annotate-command-map)

;;;###autoload (autoload 'srikkant-annotate-menu "srikkant-annotate" nil t)
(transient-define-prefix srikkant-annotate-menu ()
  "Review & Annotations scratchpad transient menu."
  [:description
   (lambda ()
     (let* ((top (srikkant-annotate--project-root))
            (notes (srikkant-annotate--get-session-notes top)))
       (format "Annotations (%d draft note%s in memory) [%s]"
               (length notes)
               (if (= (length notes) 1) "" "s")
               (abbreviate-file-name top))))
   ["Line Annotations"
    ("/"   "Add / DWIM note at point"   srikkant-annotate-dwim)
    ("n"   "Add / DWIM note at point"   srikkant-annotate-dwim)
    ("C-/" "Add / DWIM note at point"   srikkant-annotate-dwim)
    ("a"   "Add note at point"          srikkant-annotate-add-at-point)
    ("e"   "Edit note at point"         srikkant-annotate-edit-at-point)
    ("d"   "Delete note at point"       srikkant-annotate-delete-at-point)
    ("k"   "Delete note at point"       srikkant-annotate-delete-at-point)]
   ["Navigation"
    ("]"   "Next note in buffer"        srikkant-annotate-next)
    ("C-n" "Next note in buffer"        srikkant-annotate-next)
    ("["   "Previous note in buffer"    srikkant-annotate-prev)
    ("C-p" "Previous note in buffer"    srikkant-annotate-prev)
    ("j"   "Jump to note"               srikkant-annotate-jump)
    ("C-j" "Jump to note"               srikkant-annotate-jump)]
   ["Flush & Storage (Org Format)"
    ("="   "Flush draft notes (clear memory)" srikkant-annotate-save)
    ("w"   "Flush draft notes (clear memory)" srikkant-annotate-save)
    ("v"   "View .notes file (Org mode)"      srikkant-annotate-open-file)
    ("l"   "Load saved notes into memory"     srikkant-annotate-load-from-file)
    ("g"   "Refresh overlays"                 srikkant-annotate-refresh-overlays)
    ("K"   "Clear draft memory"               srikkant-annotate-clear-all)]])

;;; Hooks & Minor Modes

;;;###autoload
(define-minor-mode srikkant-annotate-mode
  "Minor mode to display review note overlays."
  :lighter " 📝"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c /") #'srikkant-annotate-menu)
            map)
  (if srikkant-annotate-mode
      (progn
        (srikkant-annotate--refresh-buffer-overlays)
        (add-hook 'magit-post-refresh-hook #'srikkant-annotate-refresh-overlays nil t)
        (add-hook 'after-save-hook #'srikkant-annotate-refresh-overlays nil t))
    (srikkant-annotate--clear-overlays)
    (remove-hook 'magit-post-refresh-hook #'srikkant-annotate-refresh-overlays t)
    (remove-hook 'after-save-hook #'srikkant-annotate-refresh-overlays t)))

(defun srikkant-annotate--auto-enable ()
  "Enable `srikkant-annotate-mode' in Magit and file buffers."
  (srikkant-annotate-mode 1))

(add-hook 'magit-diff-mode-hook #'srikkant-annotate--auto-enable)
(add-hook 'magit-status-mode-hook #'srikkant-annotate--auto-enable)
(add-hook 'find-file-hook #'srikkant-annotate--auto-enable)

;;;###autoload
(define-globalized-minor-mode global-srikkant-annotate-mode
  srikkant-annotate-mode
  (lambda ()
    (when (or (derived-mode-p 'magit-diff-mode 'magit-status-mode 'prog-mode 'text-mode)
              (buffer-file-name))
      (srikkant-annotate-mode 1))))

;; Enable global annotations and keybinding prefix C-x C-/ by default
(global-srikkant-annotate-mode 1)
(global-set-key (kbd "C-x C-/") #'srikkant-annotate-menu)
(global-set-key (kbd "C-x C-_") #'srikkant-annotate-menu)

;; Magit buffer single-key bindings (only active in read-only diff/status buffers)
(with-eval-after-load 'magit-diff
  (define-key magit-diff-mode-map (kbd "N") #'srikkant-annotate-menu)
  (define-key magit-diff-mode-map (kbd "/") #'srikkant-annotate-dwim)
  (define-key magit-diff-mode-map (kbd "=") #'srikkant-annotate-save))

(with-eval-after-load 'magit-status
  (define-key magit-status-mode-map (kbd "N") #'srikkant-annotate-menu)
  (define-key magit-status-mode-map (kbd "/") #'srikkant-annotate-dwim)
  (define-key magit-status-mode-map (kbd "=") #'srikkant-annotate-save))

;; Integrate into magit-dispatch (? in Magit)
(with-eval-after-load 'magit
  (when (fboundp 'transient-append-suffix)
    (ignore-errors
      (transient-append-suffix 'magit-dispatch "z"
        '("N" "Review annotations" srikkant-annotate-menu)))))

(provide 'srikkant-annotate)
;;; srikkant-annotate.el ends here
