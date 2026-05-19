;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme nil)
(setq doom-font (font-spec :family "Geist Mono" :size 13))
(setq display-line-numbers-type 'relative)

(add-to-list 'default-frame-alist '(undecorated-round . t))

(map! :leader
      (:prefix-map ("t" . "toggle")
       :desc "Appearance" "a" #'load-theme
       :desc "Terminal" "t" #'vterm))

(after! eglot
  (add-to-list 'eglot-stay-out-of 'eldoc))

(after! apheleia
  (setf (alist-get 'odinfmt apheleia-formatters)
        '("odinfmt" "-stdin"))
  (setf (alist-get 'odin-mode apheleia-mode-alist)
        'odinfmt))

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook ((prog-mode . copilot-mode)
         (prog-mode . copilot-nes-mode))
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
