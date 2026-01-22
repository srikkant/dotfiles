;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Cascadia Code" :size 13))
(setq display-line-numbers-type 'relative)
(setq org-directory "~/work/sync/org")

(set-frame-parameter nil 'alpha 95)

(use-package! auto-dark
  :defer t
  :init
  (setq! auto-dark-themes '((doom-homage-black) (doom-homage-white)))
  (setq! custom-safe-themes t)
  (setq! doom-theme nil)
  (auto-dark-mode)
  (map! :leader "t t" #'auto-dark-toggle-appearance))
