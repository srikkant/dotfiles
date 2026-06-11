;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(add-to-list 'default-frame-alist '(alpha-background . 90))
(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/") ;; DMS puts it's theme here

(setq doom-theme `dank-emacs)
(setq doom-font (font-spec :family "Geist Mono" :size 13))
(setq doom-variable-pitch-font (font-spec :family "Geist" :size 13))
(setq display-line-numbers-type 'relative)
(setq shell-file-name (executable-find "bash"))

(use-package! ghostel
  :config
  (map! :leader (:prefix-map "o" "t" #'ghostel)))

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
