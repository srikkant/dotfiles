local wezterm = require("wezterm")

local bg = "#000" -- Background of the window when it is not in focus.
local active_bg = "#000" -- Background of the window when it is in focus.
local fg = "#777" -- Text color for inactive tabs.
local active_fg = "#eee" -- Text color for currently selected tab.
local tab_bg = "#000" -- Background for tabs not selected.
local active_tab_bg = "#111" -- Background for the currently selected tab.

local font = wezterm.font("SF Mono")

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
	font = wezterm.font("SF Mono"),
	font_rules = {
		{
			intensity = "Bold",
			italic = true,
			font = font,
		},
		{
			intensity = "Normal",
			italic = true,
			font = font,
		},
		{
			intensity = "Half",
			italic = true,
			font = font,
		},
	},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh-preview" }
	config.font_size = 10
	config.line_height = 1.5
else
	config.font_size = 14
	config.line_height = 1.5
end

return config
