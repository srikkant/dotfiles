;;; init.el -*- lexical-binding: t; -*-

(doom! :input
       :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       (emoji +unicode)
       hl-todo
       (ligatures +extra)
       ophints
       (popup +defaults)
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
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
       (debugger +lsp)
       magit
       make
       tree-sitter

       :lang
       emacs-lisp
       markdown
       (org +roam2)
       (go +lsp +tree-sitter)
       (odin +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (web +lsp +tree-sitter)
       json

       :config
       (default +bindings +smartparens))
