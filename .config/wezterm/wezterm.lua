local wezterm = require("wezterm")
local config = wezterm.config_builder()
local config_dir = os.getenv("HOME") .. "/.config"

config.default_cursor_style = "BlinkingUnderline"
config.font = wezterm.font({ family = "Liga DM Mono" })

config.font_size = 14
config.line_height = 1.3
config.cell_width = 1.0

config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 0, top = 0, bottom = 0 }
config.tab_bar_at_bottom = true

config.webgpu_power_preference = "HighPerformance"
config.front_end = "WebGpu"

config.color_scheme = "tokyonight_night"
config.background = {
    {
        -- tokyonight's backgrounc color.
        source = { Color = "#1a1b26" },
        height = "100%",
        width = "100%",
    },
    {
        source = { File = config_dir .. "/assets/wallpapers/starfield.png" },
        hsb = { brightness = 0.25 },
        opacity = 0.1,
    },
}

config.window_frame = {
    active_titlebar_bg = "#1a1b26",
}

config.colors = {
    tab_bar = {
        active_tab = {
            bg_color = "#24283b",
            fg_color = "#c0c0c0",
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
