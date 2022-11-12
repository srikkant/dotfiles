local wezterm = require("wezterm")
local act = wezterm.action

-- There are custom color schemes defined in the color_schemes directory relative to this file.
local color_scheme_dirs = {
	wezterm.home_dir .. "/.config/wezterm/color_schemes",
}

local color_scheme = "Everforest Medium Dark"

local keys = {
	{ key = "_", mods = "SHIFT|ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "SHIFT|ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "LeftArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "RightArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "UpArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "DownArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Down", 1 }) },
}

return {
	color_scheme_dirs = color_scheme_dirs,
	color_scheme = color_scheme,
	enable_tab_bar = false,
	font_size = 15.0,
	keys = keys,
}
