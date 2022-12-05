local wezterm = require("wezterm")

local function is_dark()
	return wezterm.gui.get_appearance():find("Dark")
end

local dark = is_dark()
local bg = "#eff1f5"
local active_bg = "#dce0e8"
local fg = "#6c6f85"
local active_fg = "#4c4f69"
local tab_bg = "#e6e9ef"
local active_tab_bg = "#eff1f5"

if dark then
	bg = "#1e1e2e"
	active_bg = "#11111b"
	fg = "#a6adc8"
	active_fg = "#cdd6f4"
	tab_bg = "#1e1e2e"
	active_tab_bg = "#11111b"
end

local config = {
	font = wezterm.font_with_fallback({
		{ family = "Iosevka Extended", weight = "Medium" },
	}),
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
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh-preview" }
	config.font_size = 10
	config.line_height = 1.1
else
	config.font_size = 14
	config.line_height = 1.1
end

return config
