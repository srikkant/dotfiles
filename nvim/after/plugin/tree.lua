local status, nvim_tree = pcall(require, "nvim-tree")

if not status then
	return
end

nvim_tree.setup()

vim.keymap.set("n", "<Leader>b", ":NvimTreeToggle<CR>", { noremap = true })
