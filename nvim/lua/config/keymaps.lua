-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Some simple ways to get back to normal mode.
keymap.set("i", "kj", "<Esc>")
keymap.set("i", "jk", "<Esc>")

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- Move window
keymap.set("n", "st", "<C-w>w")
keymap.set("n", "<A-h>", "<C-w>h", opts)
keymap.set("n", "<A-j>", "<C-w>j", opts)
keymap.set("n", "<A-k>", "<C-w>k", opts)
keymap.set("n", "<A-l>", "<C-w>l", opts)

-- Resize window
keymap.set("n", "<C-k>", ":resize +2<CR>", opts)
keymap.set("n", "<C-j>", ":resize -2<CR>", opts)
keymap.set("n", "<C-l>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-h>", ":vertical resize +2<CR>", opts)

-- Improvements to paste/delete.
keymap.set("n", "<leader>d", '"_d', opts)
keymap.set("n", "<leader>p", '"_dP', opts)

-- Buffer utilities
keymap.set("n", "<C-w>", ":bd<CR>", opts)
