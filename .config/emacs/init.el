;;; init.el --- User Emacs configuration -*- lexical-binding: t -*-

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

(add-to-list 'load-path "/opt/homebrew/Library/Taps/larrasket/homebrew-emacs-liquid-glass/lisp")
(require 'lr-macos-glass)

(use-package emacs
  :ensure nil
  :config
  (setopt mode-line-collapse-minor-modes t)
  (setq-default truncate-lines t)
  (setq eldoc-echo-area-use-multiline-p nil)
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

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'modus-operandi t))
    ('dark (load-theme 'modus-vivendi t))))

(defun my/toggle-theme ()
  "Toggle between `modus-operandi' and `modus-vivendi'."
  (interactive)
  (if (memq 'modus-operandi custom-enabled-themes)
      (my/apply-theme 'dark)
    (my/apply-theme 'light)))

(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)
(when (and (boundp 'ns-system-appearance) ns-system-appearance)
  (my/apply-theme ns-system-appearance))
(keymap-global-set "C-c C-\\" #'my/toggle-theme)

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

(use-package ghostel
  :straight t
  :bind (("C-c t" . ghostel)
		 :map project-prefix-map
		 ("t" . ghostel-project)
         ("T" . ghostel-project-list-buffers)))

(use-package agy-review
  :straight nil
  :bind (("C-c r s" . agy-review-start)
         ("C-c r b" . agy-review-attach)
         ("C-c r a" . agy-review-annotate)
         ("C-c r l" . agy-review-list)
         ("C-c r f" . agy-review-flush)
         ("C-c r c" . agy-review-clear))
  :init
  (with-eval-after-load 'which-key
    (which-key-add-key-based-replacements "C-c r" "agy-review")))

(use-package vertico
  :ensure t
  :straight t
  :init (vertico-mode 1))

(use-package orderless
  :ensure t
  :straight t
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
  :straight t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package hyperbole
  :straight (hyperbole :type git
                       :host github
                       :repo "rswgnu/hyperbole")
  :demand t
  :init
  (add-to-list 'load-path
               (expand-file-name "straight/build/hyperbole/kotl" user-emacs-directory))
  :config
  (hyperbole-mode 1))

;;
;; LANGUAGE SUPPORT
;;

(use-package eglot
  :straight t
  :hook ((odin-ts-mode typescript-ts-mode tsx-ts-mode js-ts-mode
          go-ts-mode go-mod-ts-mode rust-ts-mode) . eglot-ensure)
  :bind (:map eglot-mode-map ("C-c e a" . eglot-code-actions)
              ("C-c e r" . eglot-rename)
              ("C-c e f" . eglot-format)
              ("C-c e d" . flymake-show-buffer-diagnostics))
  :config
  (add-to-list 'eglot-server-programs '(odin-ts-mode . ("ols")))
  (add-to-list 'eglot-server-programs
               '((typescript-ts-mode tsx-ts-mode js-ts-mode) . ("bunx" "tsc" "--lsp" "--stdio")))
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'eglot-format nil t)
              (when (derived-mode-p 'go-ts-mode)
                (add-hook 'before-save-hook
                          (lambda () (ignore-errors (eglot-code-action-organize-imports (point-min) (point-max))))
                          nil t)))))


(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("go\\.mod\\'" . go-mod-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(setq go-ts-mode-indent-offset 4)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'major-mode-remap-alist '(javascript-mode . js-ts-mode))
(add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode))

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

;;; init.el ends here
