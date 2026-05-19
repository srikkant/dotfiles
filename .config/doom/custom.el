;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval with-eval-after-load 'dape
      (add-to-list 'dape-configs
       '(odin-codelldb modes (odin-mode odin-ts-mode) command "codelldb"
         command-args ("--port" :autoport) port :autoport :type "lldb" :request
         "launch" :program "nbody" :cwd ".")))
     (eval setq-local compile-command
      "odin build . -debug -o:none -out:game_debug"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
