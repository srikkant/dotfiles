local wezterm = require("wezterm")
local keys = require("config.keys").keys
local ssh_domains = require("config.ssh").ssh_domains

return {
	color_scheme = "Adventure",
	color_scheme_dirs = {
		wezterm.home_dir .. "/.config/wezterm/color_schemes",
	},
	enable_tab_bar = true,
	keys = keys,
	set_environment_variables = {
		appearance = wezterm.gui.get_appearance(),
	},
	show_new_tab_button_in_tab_bar = false,
	ssh_domains = ssh_domains,
	tab_max_width = 30,
	window_padding = {
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
	},
}
