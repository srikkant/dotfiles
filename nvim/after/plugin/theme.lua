local status, catppuccin = pcall(require, "catppuccin")

if not status then
	return
end

local function get_theme()
	if vim.env.appearance:find("dark") then
		return "mocha"
	else
		return "latte"
	end
end

catppuccin.setup({
	flavour = get_theme(),
	term_colors = true,
	transparent_background = true,
})

vim.cmd.colorscheme("catppuccin")
