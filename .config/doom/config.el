;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme nil)
(setq doom-font (font-spec :family "Source Code Pro" :size 13 :weight 'medium))
(setq display-line-numbers-type 'relative)

(set-frame-parameter nil 'alpha 95)

(map! :leader
      (:prefix-map ("t" . "toggle")
       :desc "Appearance" "a" #'load-theme
       :desc "Terminal" "t" #'vterm))

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
