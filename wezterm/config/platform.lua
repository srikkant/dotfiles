local wezterm = require("wezterm")

local config = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config = {
		default_prog = { "pwsh-preview" },
		font = wezterm.font_with_fallback({
			{ family = "Iosevka Extended", weight = "Medium" },
		}),
		font_size = 10,
		line_height = 1.1,
	}
else
	config = {
		font = wezterm.font_with_fallback({ "Iosevka Extended" }),
		font_size = 14,
		line_height = 1.4,
	}
end

return config
