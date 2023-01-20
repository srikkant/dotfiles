local status, cybu = pcall(require, "cybu")

if not status then
	return
end

cybu.setup()

vim.keymap.set("n", "K", "<Plug>(CybuPrev)")
vim.keymap.set("n", "J", "<Plug>(CybuNext)")
