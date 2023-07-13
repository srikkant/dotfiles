local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Rouge 2'
config.default_cursor_style = 'BlinkingUnderline'
config.font = wezterm.font 'Cascadia Code PL'
config.font_size = 10
config.line_height = 1.4
config.cell_width = 1.1
config.tab_bar_at_bottom = true
config.window_decorations = 'RESIZE' 

config.window_frame = {
  active_titlebar_bg = '#222222',
  font_size = 9.5,
}

config.window_padding = {
  left = 24,
  right = 24,
  top = 24,
  bottom = 24,
}

config.background = {
  {
    source = { Color = "#161616" },
    opacity = 1,
    height = "100%",
    width = "100%"
  },
  {
    source = { File = '/home/srikkant/.config/wezterm/wallpaper.jpg' },
    opacity = 0.075,
  },
}

return config
