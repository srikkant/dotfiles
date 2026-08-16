;; -*- lexical-binding: t; -*-

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el" (or (bound-and-true-p straight-base-dir) user-emacs-directory)))
	  (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
	(with-current-buffer (url-retrieve-synchronously "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el" 'silent 'inhibit-cookies)
	  (goto-char (point-max))
	  (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package emacs
  :ensure nil
  :config
  (load custom-file 'noerror 'nomessage)
  (setopt mode-line-collapse-minor-modes t)

  (global-display-line-numbers-mode 1)
  (pixel-scroll-precision-mode t)

  (set-face-attribute 'default nil :family "Hasklig" :height 100)
  (set-face-attribute 'fixed-pitch nil :family "Hasklig" :height 100)
  (set-face-attribute 'variable-pitch nil :family "Source Sans 3" :height 110))

;; Set up which key first. Even if something else breaks, this will
;; help me out.

(use-package which-key
  :ensure t
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.5)
  (setq which-key-side-window-location 'bottom))

;;
;; THEME & APPEARANCE
;;

(use-package solarized-theme
  :ensure t
  :demand t
  :bind (("C-c \\" . solarized-toggle-theme))
  :config
  (load-theme 'solarized-dark t))

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  (global-ligature-mode t))

;;
;; ESSENTIAL BUILT IN PACKAGES
;;

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
		 ("C-c g" . magit-file-dispatch)))

(use-package xref
  :straight (:type built-in))

(use-package project
  :straight (:type built-in)
  :config
  (setq project-vc-extra-root-markers '(".project")))

(use-package hyperbole)

;;
;; ORG & SOME RICE
;;

(use-package org
  :straight (:type built-in)
  :custom
  (org-hide-emphasis-markers t)
  (org-ellipsis " ▾ ")
  (org-pretty-entities t)
  (org-hide-macro-markers t)
  (org-log-into-drawer t)
  (org-startup-indented t)
  :config
  (add-hook 'org-mode-hook #'visual-line-mode)
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-directory "~/sync/org")
  (setq org-agenda-files '("~/sync/org"))
  (setq org-default-notes-file "~/sync/org/todo.org"))

(use-package olivetti
  :ensure t
  :hook
  (org-mode . olivetti-mode)
  (markdown-mode . olivetti-mode)
  :custom
  (olivetti-body-width 80)
  (olivetti-style 'fancy)
  (olivetti-minimum-body-width 80))

(use-package org-modern
  :straight t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-star "replace")
  (org-modern-replace-stars "○✦◈◇★")
  (org-modern-table t)
  (org-modern-block-name t)
  (org-modern-block-fringe t)
  (org-modern-keyword t)
  (org-modern-todo t)
  (org-modern-priority t)
  (org-modern-tag t)
  (org-modern-timestamp t))

(defun my/org-style-faces ()
  (interactive)
  (variable-pitch-mode 1)

  (dolist (face '(org-block
                  org-block-begin-line
                  org-block-end-line
                  org-code
                  org-verbatim
                  org-table
                  org-formula
                  org-latex-and-related
                  org-checkbox
                  org-property-value
                  org-special-keyword
                  org-tag
                  org-meta-line
                  org-document-info-keyword
                  org-drawer
                  org-indent
                  line-number
                  line-number-current-line))
	(set-face-attribute face nil :inherit 'fixed-pitch))

  (dolist (face '(org-block
                  org-block-begin-line
                  org-block-end-line
                  org-code
                  org-date
                  org-formula
                  org-inline-src-block
                  org-latex-and-related
                  org-special-keyword
                  org-table
                  org-verbatim
				  line-number
                  line-number-current-line))
    (set-face-attribute face nil :inherit 'fixed-pitch))

  (dolist (face '(org-level-1
                  org-level-2
                  org-level-3
                  org-level-4
                  org-level-5))
    (set-face-attribute face nil
                        :inherit 'variable-pitch)))

(add-hook 'org-mode-hook #'my/org-style-faces)

;;
;; THIRD PARTY PACKAGES
;;

(use-package ghostel
  :ensure t
  :bind (("C-c t" . ghostel)
		 :map project-prefix-map
		 ("t" . ghostel-project)
         ("T" . ghostel-project-list-buffers)))

(use-package vertico
  :ensure t
  :init (vertico-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion orderless))
     (command (styles orderless))
     (variable (styles orderless))))
  (orderless-matching-styles '(orderless-regexp orderless-literal orderless-flex)))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package completion-preview
  :ensure nil
  :hook (prog-mode . completion-preview-mode)
  :bind
  ( :map completion-preview-active-mode-map
    ("M-n" . completion-preview-next-candidate)
    ("M-p" . completion-preview-prev-candidate)))

;;
;; LANGUAGE SUPPORT
;;

(use-package eglot
  :hook ((odin-ts-mode dart-mode) . eglot-ensure)
  :bind (:map eglot-mode-map ("C-c e a" . eglot-code-actions)
              ("C-c e r" . eglot-rename)
              ("C-c e f" . eglot-format)
              ("C-c e d" . flymake-show-buffer-diagnostics))
  :config
  (add-to-list 'eglot-server-programs '(odin-ts-mode . ("ols")))
  (add-to-list 'eglot-server-programs '(dart-mode . ("fvm" "dart" "language-server")))
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'eglot-format nil t))))

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package odin-ts-mode
  :straight (odin-ts-mode :type git
						  :host github
						  :repo "Sampie159/odin-ts-mode")
  :bind (:map odin-ts-mode-map
         ("C-M-d" . treesit-down-list)
         ("C-M-u" . treesit-up-list))
  :mode ("\\.odin\\'" . odin-ts-mode)
  :config
  (add-hook 'odin-ts-mode-hook
            (lambda ()
              (setq-local forward-sexp-function #'treesit-forward-sexp))))

(use-package dart-mode
  :hook (dart-mode . flutter-test-mode))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-c r" . #'flutter-run-or-hot-reload)))

;;
;; GENERAL HOOKS
;;

(dolist (mode '(eshell-mode-hook
				ghostel-mode-hook
				org-mode-hook
				markdown-mode-hook
                shell-mode-hook
                magit-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
