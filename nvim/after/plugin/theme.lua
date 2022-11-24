local status, catppuccin = pcall(require, "catppuccin")

if not status then
	return
end
catppuccin.setup({
	flavour = vim.env.CATPPUCCIN_FLAVOUR, -- latte, frappe, macchiato, mocha
	term_colors = true,
	transparent_background = true,
})

vim.cmd.colorscheme("catppuccin")
