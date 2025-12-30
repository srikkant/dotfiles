local vscode = require("vscode")

vim.g.mapleader = " "

vim.keymap.set("n", "-", function() vscode.action("workbench.view.explorer") end)
vim.keymap.set("n", "<leader>f", function() vscode.action("workbench.action.quickOpen") end)
vim.keymap.set("n", "<leader>b", function() vscode.action("workbench.action.showAllEditors") end)
vim.keymap.set("n", "<leader>/", function() vscode.action("workbench.action.findInFiles") end)
vim.keymap.set("n", "<leader>e", function() vscode.action("workbench.action.showErrorsWarnings") end)
vim.keymap.set("n", "<leader>s", function() vscode.action("workbench.action.showAllSymbols") end)
