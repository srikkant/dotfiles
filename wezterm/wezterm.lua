local wezterm = require("wezterm")
local act = wezterm.action

local font_size = 15.0
local default_prog = { "fish" }

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	font_size = 11
	default_prog = { "pwsh-preview" }
end

return {
	color_scheme_dirs = {
		wezterm.home_dir .. "/.config/wezterm/color_schemes",
	},
	color_scheme = "Everforest Medium Dark",
	default_prog = default_prog,
	font_size = font_size,
	keys = {
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
	},
}
