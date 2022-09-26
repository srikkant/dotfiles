local status, catpuccin = pcall(require, "catppuccin")
if (not status) then return end

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

catpuccin.setup()

vim.cmd [[colorscheme catppuccin]]
