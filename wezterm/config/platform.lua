local wezterm = require("wezterm")

local bg = "#282828"
local active_bg = "#282828"
local fg = "#bfbdb6"
local active_fg = "#ebdbb2"
local tab_bg = "#282828"
local active_tab_bg = "#1d2021"

local config = {
	window_decorations = "RESIZE",
	colors = {
		tab_bar = {
			active_tab = {
				bg_color = active_tab_bg,
				fg_color = active_fg,
			},
			inactive_tab = {
				bg_color = tab_bg,
				fg_color = fg,
			},
			new_tab = {
				bg_color = tab_bg,
				fg_color = fg,
			},
		},
	},
	window_frame = {
		inactive_titlebar_bg = bg,
		active_titlebar_bg = active_bg,
	},
	font = wezterm.font_with_fallback({
		{ family = "Hasklig" },
	}),
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "nu" }
	config.font_size = 10
	config.line_height = 1.1
	config.font = wezterm.font_with_fallback({
		{ family = "Iosevka Extended" },
	})
else
	config.font_size = 14
	config.line_height = 1.1
	config.font = wezterm.font_with_fallback({
		{ family = "Hasklig" },
	})
end

return config
