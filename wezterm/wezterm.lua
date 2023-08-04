local wezterm = require 'wezterm'
local env = require 'env'.load()

local config = {}

local default_wallpaper = os.getenv("HOME") .. "/.config/wezterm/wallpaper.jpg"

local wallpaper = os.getenv("TERMINAL_WALLPAPER") or env["TERMINAL_WALLPAPER"] or default_wallpaper;
local font_size = os.getenv("TERMINAL_FONT_SIZE") or env["TERMINAL_FONT_SIZE"] or 12;
local enable_tab_bar = os.getenv("TERMINAL_SHOW_TAB_BAR") or env["TERMINAL_SHOW_TAB_BAR"] or false;

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Rouge 2'
config.default_cursor_style = 'BlinkingUnderline'
config.font = wezterm.font 'Cascadia Code PL'
config.font_size = font_size
config.line_height = 1.6
config.cell_width = 1.1
config.enable_tab_bar = enable_tab_bar
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

config.background = ({
  {
    source = { Color = "#161616" },
    opacity = 1,
    height = "100%",
    width = "100%"
  },
})

if wallpaper then
  table.insert(config.background, {
    source = { File = wallpaper },
    opacity = 0.01,
  })
end

return config
