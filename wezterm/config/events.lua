local wezterm = require("wezterm")

wezterm.on("gui-startup", function()
	local _, _, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local function is_dark()
	return wezterm.gui.get_appearance():find("Dark")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local dark = is_dark()
	local edge_background = "#e6e9ef"
	local background = "#e6e9ef"

	if dark then
		edge_background = "#292c3c"
		background = "#292c3c"
	end

	if tab.is_active then
		if dark then
			background = "#626880"
		else
			background = "#acb0be"
		end
	end

	local edge_foreground = background

	local title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		"ResetAttributes",
		"ResetAttributes",
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)
