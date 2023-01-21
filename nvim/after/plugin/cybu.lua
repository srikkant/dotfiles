local status, cybu = pcall(require, "cybu")

if not status then
	return
end

cybu.setup()

vim.keymap.set("n", "<", "<Plug>(CybuPrev)")
vim.keymap.set("n", ">", "<Plug>(CybuNext)")
