;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Source Code Pro" :size 13))
(setq display-line-numbers-type 'relative)

(add-to-list 'default-frame-alist '(undecorated-round . t))
(add-to-list 'default-frame-alist '(internal-border-width . 5))
(set-frame-parameter nil 'alpha 90)

(use-package! auto-dark
  :defer t
  :init
  (setq! auto-dark-themes '((doom-homage-black) (doom-homage-white)))
  (setq! doom-theme nil)
  (setq! custom-safe-themes t)
  (map! :leader
        (:prefix-map ("t" . "toggle")
         :desc "Toggle dark mode" "h" #'auto-dark-toggle-appearance))
  (defun my-auto-dark-init-h ()
    (auto-dark-mode)
    (remove-hook 'server-after-make-frame-hook #'my-auto-dark-init-h)
    (remove-hook 'after-init-hook #'my-auto-dark-init-h))
  (let ((hook (if (daemonp)
                  'server-after-make-frame-hook
                'after-init-hook)))
    (add-hook hook #'my-auto-dark-init-h -95)))

(use-package! eat
  :config
  (setq eat-default-terminal-mode 'semi-char)
  (map! :leader
        (:prefix-map ("t" . "toggle")
         :desc "Eat Terminal" "t" #'eat
         :desc "Eat Terminal here" "v" #'eat-project)))

(use-package minuet
  :bind
  (("M-i" . #'minuet-show-suggestion)
   :map minuet-active-mode-map
   ("M-p" . #'minuet-previous-suggestion)
   ("M-n" . #'minuet-next-suggestion)
   ("M-y" . #'minuet-accept-suggestion)
   ("M-l" . #'minuet-accept-suggestion-line)
   ("M-e" . #'minuet-dismiss-suggestion))
  :init
  (add-hook 'prog-mode-hook #'minuet-auto-suggestion-mode)
  :config
  (setq minuet-provider 'gemini))

(use-package! gemini-cli
  :after (eat)
  :config
  (setq gemini-cli-terminal-backend 'eat)
  (map! :leader
        (:prefix-map ("l" . "ai")
         :desc "Start Gemini"  "c" #'gemini-cli
         :desc "Send buffer" "b" #'gemini-cli-send-buffer-file
         :desc "Send file" "f" #'gemini-cli-send-file
         :desc "Send Region" "r" #'gemini-cli-send-region
         :desc "Kill Gemini" "k" #'gemini-cli-kill
         :desc "Toggle Gemini" "t" #'gemini-cli-toggle
         :desc "Send Enter" "e" #'gemini-cli-send-return
         :desc "Send Escape" "x" #'gemini-cli-send-escape
         :desc "Send 1" "1" #'gemini-cli-send-1
         :desc "Send 2" "2" #'gemini-cli-send-2
         :desc "Send 3" "3" #'gemini-cli-send-3)))

(let ((local-config (expand-file-name "~/.emacs.local.el")))
  (when (file-exists-p local-config)
    (load local-config)))

(setq-hook! 'typescript-tsx-mode-hook
  format-all-formatters '(("TypeScript" prettier)))

(add-hook 'typescript-tsx-mode-hook #'format-all-mode)
