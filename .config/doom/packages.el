;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! alabaster-themes)
(package! auto-dark)

(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
