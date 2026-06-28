;; -*- lexical-binding: t; -*-

(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(pixel-scroll-precision-mode t)

(setopt mode-line-collapse-minor-modes t)

(setq display-line-numbers-type 'relative)
(setq-default tab-width 4)
(setq frame-resize-pixelwise t)

(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))
(add-to-list 'default-frame-alist '(undecorated-round . t))

(global-set-key (kbd "C-c <left>")  #'windmove-left)
(global-set-key (kbd "C-c <right>") #'windmove-right)
(global-set-key (kbd "C-c <up>")    #'windmove-up)
(global-set-key (kbd "C-c <down>")  #'windmove-down)

(add-to-list 'default-frame-alist '(font . "Geist Mono-13"))

(defvar bootstrap-version)
(let ((bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el" (or (bound-and-true-p straight-base-dir) user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer (url-retrieve-synchronously "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el" 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(which-key-mode 1)

(setq which-key-idle-delay 0.5)
(setq which-key-side-window-location 'bottom)

(require-theme 'modus-themes)
(global-set-key (kbd "C-c C-\\") 'modus-themes-toggle)

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

(use-package marginalia
  :ensure t
  :init (marginalia-mode 1))

(use-package consult
  :ensure t
  :bind (
         ("C-x b" . consult-buffer)
         ("C-s" . consult-line)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s m" . consult-mark)
         ("M-g a" . consult-xref)
         ("M-g g" . consult-goto-line)
         ("M-g m" . consult-mark)
         ("M-g o" . consult-outline)
         ("C-x r b" . consult-bookmark)
         ("C-x 4 b" . consult-buffer-other-window))
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

(use-package project
  :bind-keymap ("C-c p" . project-prefix-map))

(use-package corfu
  :ensure t
  :custom (corfu-cycle t)
  (corfu-auto t)
  :init (global-corfu-mode))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
		 ("C-c g" . magit-file-dispatch)))

(use-package org
  :ensure t
  :config (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture))

(use-package eshell
  :bind (("C-c s" . eshell)))

(use-package ghostel
  :ensure t
  :bind (("C-c t" . ghostel)))

(use-package odin-ts-mode
  :straight (odin-ts-mode :type git
						  :host github
						  :repo "Sampie159/odin-ts-mode"))

(use-package eglot
  :hook (odin-ts-mode . eglot-ensure)
  :bind (:map eglot-mode-map ("C-c e a" . eglot-code-actions)
              ("C-c e r" . eglot-rename)
              ("C-c e f" . eglot-format)
              ("C-c e d" . flymake-show-buffer-diagnostics))
  :hook ((odin-ts-mode) . eglot-ensure)
  :config (add-to-list 'eglot-server-programs '(odin-ts-mode . ("ols")))
  (add-hook 'odin-mode-hook (lambda ()
							  (add-hook 'before-save-hook #'eglot-format nil t))))

(add-to-list 'auto-mode-alist '("\\.odin\\'" . odin-ts-mode))

(defun my/format-elisp-buffer () "Indent the current buffer and clean up whitespace." (interactive)
       (indent-region (point-min)
					  (point-max))
       (delete-trailing-whitespace))

(add-hook 'emacs-lisp-mode-hook (lambda ()
								  (add-hook 'before-save-hook #'my/format-elisp-buffer nil t)))

(defun my/minuet-block-on-navigation ()
  (memq this-command '(next-line previous-line forward-char backward-char
								 right-char left-char mwheel-scroll scroll-up-command
								 scroll-down-command move-end-of-line move-beginning-of-line)))

(defun my/minuet-block-middle-of-word ()
  (looking-at-p "[a-zA-Z0-9_]"))

(use-package minuet
  :ensure t
  :init (add-hook 'prog-mode-hook #'minuet-auto-suggestion-mode)
  :config (setq minuet-gemini-options
				(plist-put minuet-gemini-options
						   :model "gemini-flash-lite-latest"))
  (setq minuet-auto-suggestion-block-predicates
        (list #'my/minuet-block-on-navigation
              #'my/minuet-block-middle-of-word))
  (setq minuet-provider 'gemini)
  :bind (:map minuet-active-mode-map
			  ("<tab>" . minuet-accept-suggestion)
			  ("TAB" . minuet-accept-suggestion)
			  ("<escape>" . minuet-dismiss-suggestion)
			  ("ESC" . minuet-dismiss-suggestion)))

(use-package elfeed
  :demand t
  :bind ("C-x r" . elfeed)
  :config
  (setq-default elfeed-search-filter "@1-month-ago +unread ")
  (setq elfeed-feeds
		'(("https://www.reddit.com/user/srikkant/m/srikkant.rss" reddit)
		  ("https://www.youtube.com/feeds/videos.xml?channel_id=UChk6TQce1EJMn6_liKdHDog" youtube)
		  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCUyeluBRhGPCW4rPe_UvBZQ" youtube)
		  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC8ENHE5xdFSwx71u3fDH5Xw" youtube)
		  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCaTznQhurW5AaiYPbhEA-KA" youtube)
		  ("https://thegradient.pub/rss" tech)
          ("https://www.thehindu.com/feeder/default.rss" india))))

(use-package agent-shell
  :ensure t)

(dolist (mode '(eshell-mode-hook
				ghostel-mode-hook
                shell-mode-hook
                magit-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq modus-themes-italic-constructs nil)
(setq modus-themes-common-palette-overrides modus-themes-preset-overrides-faint)
(setq modus-themes-common-palette-overrides
      '((border-mode-line-active bg-mode-line-active)
        (border-mode-line-inactive bg-mode-line-inactive)
        (bg-line-number-inactive unspecified)
		(bg-line-number-active unspecified)
		(fringe unspecified)))

(load-theme 'modus-vivendi t)

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
