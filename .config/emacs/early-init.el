;; -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)
(setq gc-cons-threshold 100000000)
(setq straight-use-package-by-default t)

(setq inhibit-startup-message t)
(setq frame-resize-pixelwise t)
(setq ring-bell-function 'ignore)
(setq display-line-numbers-type 'relative)
(setq-default tab-width 4)

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups/"))))
(setq auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq lock-file-name-transforms `((".*" ,(concat user-emacs-directory "lock-files/") t)))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . nil)))
