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
       modeline
       ophints
       (popup +defaults)
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       snippets
       (whitespace +guess +trim)

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
       magit
       make
       tree-sitter

       :lang
       emacs-lisp
       markdown
       (org +pretty +roam)
       json

       :config
       (default +bindings +smartparens))
