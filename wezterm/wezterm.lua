local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.default_cursor_style = "BlinkingUnderline"
config.font_size = 14
config.line_height = 1.3
config.cell_width = 1.0
config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 16, top = 0, bottom = 0 }
config.font = wezterm.font("IBM Plex Mono")
config.color_scheme = "Tokyo Night"
config.window_background_image = 'wallpaper.png'
config.window_background_image_hsb = {
  brightness = 0.3,
}

return config
