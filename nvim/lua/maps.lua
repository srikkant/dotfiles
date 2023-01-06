local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("i", "kj", "<Esc>")
keymap.set("i", "jk", "<Esc>")

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- New tab
keymap.set("n", "te", ":tabedit")

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- Move window
keymap.set("n", ";", "<C-w>w")
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sl", "<C-w>l", opts)

-- Resize window
keymap.set("n", "<C-k>", ":resize +2<CR>", opts)
keymap.set("n", "<C-j>", ":resize -2<CR>", opts)
keymap.set("n", "<C-l>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-h>", ":vertical resize +2<CR>", opts)

-- Improvements to paste/delete.
keymap.set("n", "<leader>d", '"_d', opts)
keymap.set("n", "<leader>p", '"_dP', opts)
