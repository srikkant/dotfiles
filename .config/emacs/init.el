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

(load custom-file 'noerror 'nomessage)
(setopt mode-line-collapse-minor-modes t)

(global-display-line-numbers-mode 1)
(pixel-scroll-precision-mode t)

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

(set-face-attribute 'default nil :family "Geist Mono" :height 100)
(set-face-attribute 'fixed-pitch nil :family "Geist Mono" :height 100)
(set-face-attribute 'variable-pitch nil :family "Geist" :height 110)

(use-package modus-themes
  :config
  (setq modus-themes-italic-constructs nil)
  (setq modus-themes-common-palette-overrides
		'((border-mode-line-active bg-mode-line-active)
		  (border-mode-line-inactive bg-mode-line-inactive)
		  (bg-line-number-inactive unspecified)
		  (bg-line-number-active unspecified)
		  (fringe unspecified)))
  :bind
  (("C-c C-\\" . modus-themes-toggle)))

;;
;; ESSENTIAL BUILT IN PACKAGES
;;

(use-package emacs
  :ensure nil
  :bind
  (("C-c [" . next-error)
   ("C-c ]" . next-error)))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
		 ("C-c g" . magit-file-dispatch)))

(use-package eshell
  :straight (:type built-in)
  :bind (("C-c s" . eshell)))

(use-package windmove
  :straight (:type built-in)
  :ensure t
  :bind (("C-c <up>" . windmove-up)
		 ("C-c <down>" . windmove-down)
		 ("C-c <left>" . windmove-left)
		 ("C-c <right>" . windmove-right)))

(use-package project
  :straight (:type built-in)
  :config
  (setq project-vc-extra-root-markers '(".project"))
  :ensure t)

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
  (setq org-outline-path-complete-in-steps nil))

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

(use-package olivetti
  :ensure t
  :hook
  (org-mode . olivetti-mode)
  :custom
  (olivetti-body-width 80)
  (olivetti-style 'fancy)
  (olivetti-minimum-body-width 80))

(defun my/org-style-faces ()
  (interactive)
  (display-line-numbers-mode -1)
  (setq fill-column 80)

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

(use-package corfu
  :ensure t
  :custom (corfu-cycle t)
  (corfu-auto t)
  :init (global-corfu-mode))

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
  (orderless-matching-styles '(orderless-regexp orderless-flex)))

(use-package consult
  :ensure t
  :bind (
         ("C-x b" . consult-buffer)
         ("C-x B" . consult-buffer-other-window)
         ("C-s" . consult-line)
         ("C-c r" . consult-ripgrep)
         ("C-c m" . consult-mark)
         ("C-c g" . consult-xref)
         ("C-c m" . consult-mark)
         ("C-c o" . consult-outline))
  :config
  (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git"))))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)

(use-package embark-consult
  :ensure t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;;
;; LANGUAGE SUPPORT
;;

(use-package eglot
  :hook ((odin-ts-mode js-ts-mode) . eglot-ensure)
  :bind (:map eglot-mode-map ("C-c e a" . eglot-code-actions)
              ("C-c e r" . eglot-rename)
              ("C-c e f" . eglot-format)
              ("C-c e d" . flymake-show-buffer-diagnostics))
  :config
  (add-to-list 'eglot-server-programs '(odin-ts-mode . ("ols")))
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

;;
;; AI
;;

(use-package agent-shell
  :ensure t)

(use-package minuet
  :ensure t
  :bind
  (("M-y" . #'minuet-complete-with-minibuffer)
   ("M-i" . #'minuet-show-suggestion)
   :map minuet-active-mode-map
   ("M-p" . #'minuet-previous-suggestion)
   ("M-n" . #'minuet-next-suggestion)
   ("M-a" . #'minuet-accept-suggestion)
   ("M-A" . #'minuet-accept-suggestion-line)
   ("M-e" . #'minuet-dismiss-suggestion))
  :config
  (require 'minuet-duet)
  (setq minuet-gemini-options
		(plist-put minuet-gemini-options
				   :model "gemini-flash-lite-latest"))
  (setq minuet-provider 'gemini))

(use-package minuet-duet
  :straight nil
  :after minuet
  :bind
  (("C-c d" . #'minuet-duet-predict)
   :map minuet-duet-active-mode-map
   ("M-a" . #'minuet-duet-apply)
   ("M-e" . #'minuet-duet-dismiss))
  :config
  (setq minuet-duet-provider 'gemini))

;;
;; MISCELLANEOUS
;;

(use-package elfeed
  :demand t
  :bind ("C-x r" . elfeed)
  :config
  (setq-default elfeed-search-filter "@1-month-ago +unread")
  (setq elfeed-feeds
		'(("https://www.reddit.com/user/srikkant/m/srikkant.rss" reddit)
		  ("https://www.youtube.com/feeds/videos.xml?channel_id=UChk6TQce1EJMn6_liKdHDog" youtube)
		  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCUyeluBRhGPCW4rPe_UvBZQ" youtube)
		  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC8ENHE5xdFSwx71u3fDH5Xw" youtube)
		  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCaTznQhurW5AaiYPbhEA-KA" youtube)
		  ("https://thegradient.pub/rss" tech))))

;;
;; GENERAL HOOKS
;;

(dolist (mode '(eshell-mode-hook
				ghostel-mode-hook
                shell-mode-hook
                magit-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(load-theme 'modus-vivendi t)

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
