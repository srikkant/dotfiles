local wezterm = require("wezterm")
local config = wezterm.config_builder()
local config_dir = os.getenv("HOME") .. "/.config"

local color_scheme = "rose-pine"
local colors = wezterm.color.get_builtin_schemes()[color_scheme]

config.default_cursor_style = "BlinkingUnderline"
config.font = wezterm.font({ family = "Liga DM Mono" })

config.font_size = 14
config.line_height = 1.1
config.cell_width = 1.0

config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 0, top = 0, bottom = 0 }
config.tab_bar_at_bottom = true

config.webgpu_power_preference = "HighPerformance"
config.front_end = "WebGpu"

config.color_scheme = "rose-pine"
config.background = {
    {
        source = { Color = colors.background },
        height = "100%",
        width = "100%",
    },
    {
        source = { File = config_dir .. "/assets/wallpapers/starfield.png" },
        hsb = { brightness = 0.1 },
        opacity = 0.05,
    },
}

config.window_frame = {
    active_titlebar_bg = colors.background,
}

config.colors = {
    tab_bar = {
        active_tab = {
            bg_color = "#24283b",
            fg_color = colors.foreground,
        },
        inactive_tab = {
            bg_color = "#1a1b26",
            fg_color = "#808080",
        },
        inactive_tab_hover = {
            bg_color = "#1a1b26",
            fg_color = "#c0c0c0",
        },
        new_tab = {
            bg_color = "#1a1b26",
            fg_color = "#808080",
        },
        new_tab_hover = {
            bg_color = "#1a1b26",
            fg_color = "#c0c0c0",
        },
    },
}

return config
