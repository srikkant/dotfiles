local wezterm = require("wezterm")
local keys = require("config.keys").keys
local ssh_domains = require("config.ssh").ssh_domains

return {
	color_scheme_dirs = {
		wezterm.home_dir .. "/.config/wezterm/color_schemes",
	},
	color_scheme = "Everforest Medium Dark",
	enable_tab_bar = true,
	font = wezterm.font_with_fallback({ "Iosevka Extended" }),
	keys = keys,
	line_height = 1.1,
	ssh_domains = ssh_domains,
}
