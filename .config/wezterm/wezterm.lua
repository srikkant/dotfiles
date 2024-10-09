local wezterm = require("wezterm")
local config = wezterm.config_builder()
local color_scheme = "rose-pine"
local action = wezterm.action

config.term = "wezterm"

config.default_cursor_style = "BlinkingUnderline"

config.font_size = 14
config.line_height = 1.2
config.cell_width = 1.0

config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true

config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 0, top = 0, bottom = 0 }
config.window_frame = { font_size = 11 }

config.webgpu_power_preference = "HighPerformance"
config.front_end = "WebGpu"

config.color_scheme = color_scheme

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    -- first binding to make sure leader command can still be sent inside
    { key = "a", mods = "LEADER|CTRL", action = action.SendKey({ key = "a", mods = "CTRL" }) },
    { key = "%", mods = "LEADER|SHIFT", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "\"", mods = "LEADER|SHIFT", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "c", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") },
    { key = "h", mods = "LEADER", action = action.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = action.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = action.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = action.ActivatePaneDirection("Right") },
    { key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
    { key = "x", mods = "LEADER", action = action.CloseCurrentPane({ confirm = false }) },
    { key = "`", mods = "ALT", action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
    {
        key = "n",
        mods = "LEADER",
        action = action.PromptInputLine({
            description = wezterm.format({ { Text = "Workspace name" } }),
            action = wezterm.action_callback(function(window, pane, line)
                if line then window:perform_action(action.SwitchToWorkspace({ name = line }), pane) end
            end),
        }),
    },
}

wezterm.on(
    "update-right-status",
    function(window, pane) window:set_right_status(window:active_workspace() .. "    ") end
)

return config
