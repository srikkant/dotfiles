local wezterm = require("wezterm")
local act = wezterm.action

return {
    color_scheme_dirs = {
        wezterm.home_dir .. "/.config/wezterm/color_schemes",
    },
    color_scheme = "Everforest Medium Dark",
    enable_tab_bar = false,
    keys = {
        { key = "L", mods = "SHIFT|ALT", action = wezterm.action.ShowLauncher },
        { key = "_", mods = "SHIFT|ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "|", mods = "SHIFT|ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
        { key = "LeftArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Left", 1 }) },
        { key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
        { key = "RightArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Right", 1 }) },
        { key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
        { key = "UpArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Up", 1 }) },
        { key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
        { key = "DownArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Down", 1 }) },
    },
}
