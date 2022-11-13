local wezterm = require("wezterm")
local keys = require("config.keys").keys

return {
	color_scheme_dirs = {
		wezterm.home_dir .. "/.config/wezterm/color_schemes",
	},
	color_scheme = "Everforest Medium Dark",
	enable_tab_bar = false,
	font = wezterm.font_with_fallback({ "SF Mono" }),
	keys = keys,
	line_height = 1.4,
}
