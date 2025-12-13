(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

(use-package modus-themes
  :ensure t
  :config
  (setq modus-themes-common-palette-overrides
        '(
          (bg-mode-line-active bg-main)
          (bg-mode-line-inactive bg-main)
          (fg-mode-line-active fg-main)
          (fg-mode-line-inactive fg-dim)))
  (setq modus-themes-mode-line '(accented borderless))
  (modus-themes-load-theme (if (eq (frame-parameter nil 'background-mode) 'dark)
                               'modus-vivendi
                               'modus-operandi)))

(defun my/apply-theme (appearance)
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'modus-operandi t))
    ('dark  (load-theme 'modus-vivendi t))))

(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)

(defun my/set-internal-border-color (&rest _args)
  (set-face-background 'internal-border (face-attribute 'default :background)))

(advice-add 'load-theme :after #'my/set-internal-border-color)
(my/set-internal-border-color)

(dolist (mode '(org-mode-hook term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package project
  :ensure t
  :config
  (setq project-switch-commands 'project-find-file))

(use-package emacs
  :config
  (add-to-list 'default-frame-alist '(undecorated-round . t))
  (add-to-list 'default-frame-alist '(internal-border-width . 5))
  (set-face-background 'internal-border (face-attribute 'default :background))
  (set-frame-font "Cascadia Code 13" nil t)
  (set-frame-parameter nil 'alpha 95)

  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (set-fringe-mode 10)
  (menu-bar-mode -1)
  (tab-bar-mode 1)
  (global-display-line-numbers-mode t)

  (setq display-line-numbers-type 'relative)
  (setq tab-bar-close-button-show nil)
  (setq tab-bar-new-button-show nil)
  (setq tab-bar-format nil)
  (setq use-package-always-ensure t) 
  (setq inhibit-startup-message t)
  (setq visible-bell t)

  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (evil-set-undo-system 'undo-redo))

(use-package evil-collection
  :after evil
  :init
  :custom
  (evil-collection-want-find-usages-bindings t)
  (evil-collection-key-blacklist '("gr"))
  :init
  (evil-collection-init))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode))

(use-package vertico
  :init
  (vertico-mode))

(use-package marginalia
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t)     
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'first)
  :bind
  (:map corfu-map
        ("C-y" . corfu-insert))
  :config
  (corfu-popupinfo-mode))

(use-package eglot
  :ensure t
  :hook 
  ((c-mode . eglot-ensure)
   (c++-mode . eglot-ensure)
   (eglot-managed-mode . my/enable-eglot-format-on-save))

  :config
  (setq eglot-events-buffer-size 0)
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider))
  (defun my/enable-eglot-format-on-save ()
    (add-hook 'before-save-hook #'eglot-format-buffer -10 t))

  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd")))


(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-diff-refine-hunk nil)
  (magit-revision-show-gravatars nil)
  (magit-show-long-lines-warning nil)
  :hook
  (magit-mode . (lambda () (hl-line-mode -1))))

;; Global I/O tweak
(setq vc-handled-backends '(Git))

(use-package which-key
    :config
    (which-key-mode))

(use-package general
  :config
  (general-define-key
    :states 'normal
    :keymaps 'eglot-mode-map

    "gd" '(xref-find-definitions :which-key "goto def")
    "gD" '(xref-find-definitions-other-window :which-key "goto def other win")
    "grr" '(xref-find-references :which-key "references")
    "gra" '(eglot-code-actions :which-key "code actions")
    "grn" '(eglot-rename :which-key "rename")
    "grf" '(eglot-format :which-key "format")
    "K"  '(eldoc :which-key "hover")
    "[d" '(flymake-goto-prev-error :which-key "prev error")
    "]d" '(flymake-goto-next-error :which-key "next error"))

  (general-create-definer my/leader-def
    :prefix "SPC")

  (my/leader-def
    :states 'normal
    "g"  '(:ignore t :which-key "git")

    "p" '(:keymap project-prefix-map :which-key "project")
    "f" 'project-find-file
    "/" 'consult-ripgrep
    "b" 'consult-project-buffer
    "m" '(compile :which-key "run make")
    "M" '(recompile :which-key "rerun last make")
    "gg" '(magit-status :which-key "status")
    "gb" '(magit-blame :which-key "blame")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
