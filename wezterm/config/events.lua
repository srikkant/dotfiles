local wezterm = require("wezterm")

wezterm.on("gui-startup", function()
	local _, _, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#2f383e"
	local background = "#2f383e"
	local foreground = "#4b565c"

	if tab.is_active then
		background = "#2f383e"
		foreground = "#d3c6aa"
	end

	local edge_foreground = background

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = tab.active_pane.title },
		{ Background = { Color = edge_background } },
	}
end)
