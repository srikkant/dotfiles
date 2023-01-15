local status, alpha = pcall(require, "alpha")

if not status then
	return
end

local dashboard_status, dashboard = pcall(require, "alpha.themes.dashboard")

if not dashboard_status then
	return
end

-- Set header
dashboard.section.header.val = {
	" ██╗    ██╗███████╗     █████╗ ██████╗ ███████╗    ██╗██╗  ██╗██╗  ██╗ █████╗  ",
	" ██║    ██║██╔════╝    ██╔══██╗██╔══██╗██╔════╝    ██║██║ ██╔╝██║ ██╔╝██╔══██╗ ",
	" ██║ █╗ ██║█████╗      ███████║██████╔╝█████╗      ██║█████╔╝ █████╔╝ ███████║ ",
	" ██║███╗██║██╔══╝      ██╔══██║██╔══██╗██╔══╝      ██║██╔═██╗ ██╔═██╗ ██╔══██║ ",
	" ╚███╔███╔╝███████╗    ██║  ██║██║  ██║███████╗    ██║██║  ██╗██║  ██╗██║  ██║██╗",
	"  ╚══╝╚══╝ ╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝",
}

-- Set menu
dashboard.section.buttons.val = {
	dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
	dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
	dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

alpha.setup(dashboard.opts)
