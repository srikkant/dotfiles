;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! ghostel)
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
