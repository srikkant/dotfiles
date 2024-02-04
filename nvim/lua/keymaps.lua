local function keymap(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

keymap("n", "U", "<cmd>redo<cr>")

keymap("x", "<leader>p", [["_dP]])
keymap("n", "<leader>Y", [["+Y]])
keymap({ "n", "v" }, "<leader>y", [["+y]])

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

keymap("n", "<leader>tn", "<cmd>tabnext<CR>")
keymap("n", "<leader>tp", "<cmd>tabprev<CR>")
keymap("n", "<leader>tt", "<cmd>tabnew<CR>")
keymap("n", "<leader>td", "<cmd>tabclose<CR>")
