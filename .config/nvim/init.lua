local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local spec = {
    { import = "srikkant.common" }
}

if vim.g.vscode then
    table.insert(spec, { import = "srikkant.vscode" })
else
    table.insert(spec, { import = "srikkant.nvim" })
end

require("lazy").setup({ spec = spec })