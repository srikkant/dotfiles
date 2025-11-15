local vscode = require("vscode")

vim.notify = vscode.notify

vim.keymap.set({ "n", "v" }, "-", function() 
    vscode.action("workbench.view.explorer")
end)

vim.keymap.set({ "n", "v" }, "<leader>b", function()
    vscode.action("workbench.action.showAllEditors")
end)

vim.keymap.set({ "n", "v" }, "<leader>f", function() 
    vscode.action("workbench.action.quickOpen")
end)

vim.keymap.set({ "n", "v" }, "<leader>/", function()
    vscode.action("workbench.action.findInFiles")
end)

vim.keymap.set({ "n", "v" }, "<leader>e", function()
    vscode.action("workbench.actions.view.problems")
end)

vim.keymap.set({ "n", "v" }, "[d", function()
    vscode.action("editor.action.marker.prev")
end)

vim.keymap.set({ "n", "v" }, "]d", function()
    vscode.action("editor.action.marker.next")
end)

return {};
