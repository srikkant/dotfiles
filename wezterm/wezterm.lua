local wezterm = require "wezterm"
local mux = wezterm.mux

function scheme_for_appearance(appearance)
	  if appearance:find "Dark" then
		    return "Catppuccin Mocha"
	  else
	  	  return "Catppuccin Latte"
	  end
end

wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

return {
    color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
    default_cwd = "/Users/srikkant/Work",
    font_size = 13,
    enable_tab_bar = false
}
