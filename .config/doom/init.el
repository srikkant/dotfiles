;;; init.el -*- lexical-binding: t; -*-

(doom! :input
       :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       (emoji +unicode)
       hl-todo
       ligatures
       ophints
       (popup +defaults)
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave +apheleia)
       snippets

       :emacs
       dired
       electric
       undo
       vc

       :term
       eshell
       vterm

       :checkers
       syntax

       :tools
       (eval +overlay)
       (lookup +docsets)
       (lsp +eglot)
       debugger
       magit
       make
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       emacs-lisp
       markdown
       (org +pretty +roam)
       (go +lsp + tree-sitter)
       (odin +lsp)
       json

       :config
       (default +bindings +smartparens))
