local opts = { noremap = true, silent = true }

vim.keymap.set("n", "U", "<cmd>redo<cr>", opts)

vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", opts)
vim.keymap.set("n", "<leader>tp", "<cmd>tabprev<CR>", opts)
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", opts)
vim.keymap.set("n", "<leader>td", "<cmd>tabclose<CR>", opts)

-- greatest remap ever: theprimeagen
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and

--
-- following helix like keymaps for windows., < leader + w > feels easier than < ctrl + w >.
vim.keymap.set("n", "<leader>w", "<C-w>", opts)
