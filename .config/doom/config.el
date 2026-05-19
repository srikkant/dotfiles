;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(set-frame-parameter nil 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(add-to-list 'default-frame-alist '(undecorated-round . t))

(setq doom-theme nil)
(setq doom-font (font-spec :family "Geist Mono" :size 13))
(setq display-line-numbers-type 'relative)
(setq shell-file-name (executable-find "bash"))

(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))

(after! eglot
  (add-to-list 'eglot-stay-out-of 'eldoc))

(after! projectile
  (add-to-list 'projectile-ignored-projects (expand-file-name "~/") t))

(add-hook! '(odin-mode-hook)
  (after! apheleia
    (setf (alist-get 'odinfmt apheleia-formatters) '("odinfmt" "-stdin"))
    (setf (alist-get 'odin-mode apheleia-mode-alist) 'odinfmt)
    (setf (alist-get 'odin-ts-mode apheleia-mode-alist) 'odinfmt)))

(use-package! auto-dark
  :defer t
  :init
  (setq auto-dark-themes '((alabaster-themes-dark) (alabaster-themes-light-bg)))
  (setq doom-theme nil)
  (setq custom-safe-themes t)
  (defun s-auto-dark-init-h ()
    (auto-dark-mode)
    (remove-hook 'server-after-make-frame-hook #'s-auto-dark-init-h)
    (remove-hook 'after-init-hook #'s-auto-dark-init-h))
  (let ((hook (if (daemonp)
                  'server-after-make-frame-hook
                'after-init-hook)))
    (add-hook hook #'s-auto-dark-init-h -95)))

(use-package! copilot
  :hook ((prog-mode . copilot-mode)
         (prog-mode . copilot-nes-mode))
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)))

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
