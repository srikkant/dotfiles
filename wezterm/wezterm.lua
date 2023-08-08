local wezterm = require "wezterm"
local config = wezterm.config_builder()

local appearance = wezterm.gui.get_appearance()
local font_size = os.getenv("TERMINAL_FONT_SIZE") or "13";

config.default_cursor_style = "BlinkingUnderline"
config.color_scheme = "Gruvbox Light"
config.font = wezterm.font ("Cascadia Code PL", { weight  = "DemiBold" })
config.font_size = tonumber(font_size)
config.line_height = 1.6
config.cell_width = 1.05
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 16, top = 0, bottom = 0 }
config.set_environment_variables = { APPEARANCE = "light" }

-- Dark mode overrides. 
if appearance:find "Dark" then
  config.font = wezterm.font ("Cascadia Code PL", { weight  = "Regular" })
  config.set_environment_variables["APPEARANCE"] = "dark"
  config.color_scheme = "Gruvbox dark, hard (base16)"
end

return config
