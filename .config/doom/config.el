;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme nil)
(setq doom-font (font-spec :family "Source Code Pro" :size 13 :weight 'medium))
(setq display-line-numbers-type 'relative)

(add-to-list 'default-frame-alist '(undecorated-round . t))

(map! :leader
      (:prefix-map ("t" . "toggle")
       :desc "Appearance" "a" #'load-theme
       :desc "Terminal" "t" #'vterm))

(after! eglot
  (add-to-list 'eglot-stay-out-of 'eldoc))

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
