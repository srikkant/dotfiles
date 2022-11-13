local wezterm = require("wezterm")

local config = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config = {
        font_size = 11,
        default_prog = { "pwsh-preview" }
    }
else
    config = {
        font_size = 15,
    }
end

return config
