local status, nightfox = pcall(require, "nightfox")

if not status then
	return
end

nightfox.setup({})

vim.cmd("colorscheme carbonfox")
