local status, theme = pcall(require, "gruvbox")

if not status then
	return
end

theme.setup({
	contrast = "hard",
})

vim.cmd("colorscheme gruvbox")
