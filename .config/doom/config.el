;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(add-to-list 'default-frame-alist '(alpha-background . 90))

(setq doom-font (font-spec :family "Hasklig" :size 13 :weight 'SemiBold))
(setq display-line-numbers-type 'relative)
(setq shell-file-name (executable-find "bash"))
(setq doom-theme 'doom-gruvbox)

(use-package! ghostel
  :config
  (map! :leader (:prefix-map ("o" . "open") "t" #'ghostel)))

(use-package! copilot
  :hook ((prog-mode . copilot-mode)
         (prog-mode . copilot-nes-mode))
  :config
  (setq copilot-indent-offset-warning-disable t)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)))

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
