local wezterm = require "wezterm"
local env = require "env"

local config = wezterm.config_builder()

config.default_cursor_style = "BlinkingUnderline"
config.color_scheme = "Gruvbox Light"
config.font = wezterm.font("Cascadia Code PL")
config.font_size = env["font_size"]
config.line_height = env["line_height"]
config.cell_width = env["cell_width"]
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 16, top = 0, bottom = 0 }
config.set_environment_variables = { APPEARANCE = "light" }

-- Dark mode overrides.
if env["appearance"]:find "Dark" then
  config.font = wezterm.font("Cascadia Code PL")
  config.set_environment_variables["APPEARANCE"] = "dark"
  config.color_scheme = "Gruvbox Dark (Gogh)"
end

return config
