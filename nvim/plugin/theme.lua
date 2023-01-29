local status, theme = pcall(require, "gruvbox")

if not status then
	return
end

theme.setup({
	contrast = "soft", -- can be "hard", "soft" or empty string
	italic = false,
	transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")
