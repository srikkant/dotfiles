local wezterm = require("wezterm")

-- There are custom color schemes defined in the color_schemes directory relative to this file.
local color_scheme_dirs = {
	wezterm.home_dir .. "/.config/wezterm/color_schemes",
}

local color_scheme = "Everforest Medium Dark"

return {
	color_scheme_dirs = color_scheme_dirs,
	color_scheme = color_scheme,
	enable_tab_bar = false,
	font_size = 15.0,
}
