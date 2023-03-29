-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ts", "*.tsx" },
    callback = function()
        local typescript = require("typescript")
        typescript.actions.organizeImports({ sync = true })
        typescript.actions.addMissingImports({ sync = true })
        typescript.actions.fixAll({ sync = true })
    end,
})
