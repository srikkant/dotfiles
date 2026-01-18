(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

(use-package project
  :ensure t
  :config
  (setq project-switch-commands 'project-find-file)
  (setq project-vc-extra-root-markers '(".project")))

(use-package org
  :ensure t
  :config
  (setq org-startup-indented t)
  (setq org-hide-emphasis-markers t)
  (setq org-agenda-files '("~/work/sync/org")))

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

(defun my/dired ()
  (interactive)
  (if (project-current)
      (project-dired)
    (dired default-directory)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-normal-state-cursor 'box)
  (setq evil-insert-state-cursor 'bar) 

  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-normal-state-map (kbd "-") 'my/dired)
  (evil-set-undo-system 'undo-redo))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-want-find-usages-bindings t)
  (evil-collection-key-blacklist '("gr"))
  :init
  (evil-collection-init))

(use-package evil-org
  :ensure t
  :config
  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)
  (add-hook 'org-mode-hook 'evil-org-mode))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode))

(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package general
  :config
  (general-create-definer my/leader-def
    :prefix "SPC")
  (my/leader-def
    :states 'normal
    "p" '(:keymap project-prefix-map :which-key "project")
    "f" 'project-find-file
    "/" 'consult-ripgrep
    "b" 'consult-project-buffer))

