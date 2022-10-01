local status, catpuccin = pcall(require, "catppuccin")
if (not status) then return end

vim.g.catppuccin_flavour = vim.env.CATPPUCCIN_FLAVOUR

catpuccin.setup()

vim.cmd [[colorscheme catppuccin]]
