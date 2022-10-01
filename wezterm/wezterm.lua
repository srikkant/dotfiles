local wezterm = require "wezterm"

function scheme_for_appearance(appearance)
	  if appearance:find "Dark" then
		    return "Catppuccin Mocha"
	  else
	  	  return "Catppuccin Latte"
	  end
end

return {
	  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
    font_size = 13,
    enable_tab_bar = false
}
