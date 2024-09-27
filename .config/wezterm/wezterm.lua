local wezterm = require("wezterm")
local config = wezterm.config_builder()
local color_scheme = "rose-pine"

config.term = "wezterm"

config.default_cursor_style = "BlinkingUnderline"

config.font_size = 14
config.line_height = 1.1
config.cell_width = 1.0

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 0, top = 0, bottom = 0 }
config.tab_bar_at_bottom = true

config.webgpu_power_preference = "HighPerformance"
config.front_end = "WebGpu"

config.color_scheme = color_scheme

return config
