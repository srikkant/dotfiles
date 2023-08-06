local wezterm = require "wezterm"
local config = wezterm.config_builder()

local appearance = wezterm.gui.get_appearance()
local font_size = os.getenv("TERMINAL_FONT_SIZE") or 13;

config.default_cursor_style = "BlinkingUnderline"
config.color_scheme = "Gruvbox Light"
config.font = wezterm.font "Cascadia Code PL"
config.font_size = font_size
config.line_height = 1.6
config.cell_width = 1.1
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = { left = 24, right = 16, top = 0, bottom = 0 }
config.set_environment_variables = { APPEARANCE = "light" }

-- Dark mode overrides. 
if appearance:find "Dark" then
  config.set_environment_variables["APPEARANCE"] = "dark"
  config.color_scheme = "Gruvbox Dark"
end

return config
