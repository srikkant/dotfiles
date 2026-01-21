;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Cascadia Code" :size 13))
(setq display-line-numbers-type 'relative)

(add-to-list 'default-frame-alist '(undecorated-round . t))
(add-to-list 'default-frame-alist '(internal-border-width . 5))
(set-frame-parameter nil 'alpha 95)

(use-package! auto-dark
  :defer t
  :init
  (setq! auto-dark-themes '((doom-homage-black) (doom-homage-white)))
  (setq! doom-theme nil)
  (setq! custom-safe-themes t)
  (map! :leader "t t" #'auto-dark-toggle-appearance)
  (defun my-auto-dark-init-h ()
    (auto-dark-mode)
    (remove-hook 'server-after-make-frame-hook #'my-auto-dark-init-h)
    (remove-hook 'after-init-hook #'my-auto-dark-init-h))
  (let ((hook (if (daemonp)
                  'server-after-make-frame-hook
                'after-init-hook)))
    (add-hook hook #'my-auto-dark-init-h -95)))
