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
(setq straight-built-in-pseudo-packages
      '(xref project eldoc eglot))

(when (and (boundp 'custom-file) custom-file (file-exists-p custom-file))
  (load custom-file 'noerror 'nomessage))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(use-package emacs
  :ensure nil
  :config
  (setopt mode-line-collapse-minor-modes t)
  (setq-default truncate-lines t)
  (setq eldoc-echo-area-use-multiline-p nil)
  (global-display-line-numbers-mode 1)
  (pixel-scroll-precision-mode t))

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

(straight-use-package
 '(nano :type git :host github :repo "rougier/nano-emacs"))

(require 'nano-base-colors)
(require 'nano-faces)
(require 'nano-theme)
(require 'nano-layout)

(defun nano-theme-set-light ()
  "Apply Alabaster light theme base for Nano."
  (setq frame-background-mode    'light)
  (setq nano-color-foreground "#000000") ;; Alabaster FG (black)
  (setq nano-color-background "#F7F7F7") ;; Alabaster BG
  (setq nano-color-highlight  "#F0F0F0") ;; Line highlight / active line
  (setq nano-color-critical   "#AA3731") ;; Red / comments & errors
  (setq nano-color-salient    "#325CC0") ;; Blue / definitions & functions
  (setq nano-color-strong     "#000000") ;; Black / bold elements
  (setq nano-color-popout     "#7A3E9D") ;; Magenta / constants & symbols
  (setq nano-color-subtle     "#BFDBFE") ;; Light blue / selection & modeline
  (setq nano-color-faded      "#777777") ;; Grey / punctuation & dim text
  (setq nano-theme-var "light"))

(defun nano-theme-set-dark ()
  "Apply Alabaster dark theme base for Nano."
  (setq frame-background-mode     'dark)
  (setq nano-color-foreground "#CECECE") ;; Light grey / base text
  (setq nano-color-background "#0E1415") ;; Dark teal-black BG
  (setq nano-color-highlight  "#1A2426") ;; Current line highlight
  (setq nano-color-critical   "#F06560") ;; Bright coral red / comments & errors
  (setq nano-color-salient    "#70B0FF") ;; Light blue / definitions & functions
  (setq nano-color-strong     "#FFFFFF") ;; Pure white / bold elements
  (setq nano-color-popout     "#D994FF") ;; Soft lavender / constants & symbols
  (setq nano-color-subtle     "#233336") ;; Muted dark teal / selection & modeline
  (setq nano-color-faded      "#6C7D80") ;; Muted cyan-grey / punctuation & dim text
  (setq nano-theme-var "dark"))

(defun my/set-font-faces ()
  (set-face-attribute 'default nil :family "OverpassM Nerd Font Mono" :height 110)
  (set-face-attribute 'fixed-pitch nil :family "OverpassM Nerd Font Mono" :height 110)
  (set-face-attribute 'variable-pitch nil :family "Overpass" :height 130))

(defun my/toggle-theme ()
  (interactive)
  (nano-toggle-theme)
  (my/set-font-faces))

(setq nano-font-family-monospaced "OverpassM Nerd Font Mono")
(setq nano-font-family-proportional "Overpass")
(setq nano-font-size 11)
(nano-theme-set-dark)
(nano-faces)
(nano-theme)
(my/set-font-faces)

(require 'nano-layout)
(require 'nano-modeline)

(keymap-global-set "C-c \\" #'my/toggle-theme)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;
;; SRIKKANT
;;

(use-package srikkant-annotate
  :straight nil
  :demand t
  :bind (("C-x C-/" . srikkant-annotate-menu)))

;;
;; ESSENTIAL BUILT IN PACKAGES
;;

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
		 ("C-c g" . magit-file-dispatch)))

(use-package eshell
  :straight (:type built-in)
  :bind (("C-c s" . eshell)))

(use-package project
  :straight (:type built-in)
  :config
  (setq project-vc-extra-root-markers '(".project")))

(use-package ligature
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  (global-ligature-mode t))

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
  (setq org-directory "~/Google Drive/My Drive/sync/org")
  (setq org-agenda-files (directory-files-recursively org-directory "\\.org$"))
  (setq org-default-notes-file (concat org-directory "/todo.org")))

(use-package org-roam
  :demand t
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture))
  :config
  (setq org-roam-directory "~/Google Drive/My Drive/sync/org/roam")
  (org-roam-db-autosync-mode))

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

(use-package completion-preview
  :ensure nil
  :hook (prog-mode . completion-preview-mode)
  :config
  (setq completion-show-help nil)
  (setq completions-header-format nil)
  (setq completions-format 'one-column)
  (setq completions-max-height 15)
  (setq completions-detailed t)
  :bind
  (:map completion-preview-active-mode-map
		("M-n" . completion-preview-next-candidate)
		("M-p" . completion-preview-prev-candidate)))

;;
;; THIRD PARTY PACKAGES
;;

(use-package hyperbole)

(use-package mise
  :config
  (global-mise-mode))

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
  (add-to-list 'eglot-server-programs '(dart-mode . ("dart" "language-server" "--client-id" "emacs.eglot-dart")))
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
  :mode ("\\.odin\\'" . odin-ts-mode)
  :config
  (add-hook 'odin-ts-mode-hook
            (lambda ()
              (setq-local forward-sexp-function #'treesit-forward-sexp))))

(use-package dart-mode
  :hook (dart-mode . flutter-test-mode))

(use-package flutter
  :demand
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
