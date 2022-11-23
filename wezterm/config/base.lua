local wezterm = require("wezterm")
local keys = require("config.keys").keys
local ssh_domains = require("config.ssh").ssh_domains

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Everforest Medium Dark"
	else
		return "Everforest Medium Dark"
	end
end

return {
	color_scheme_dirs = {
		wezterm.home_dir .. "/.config/wezterm/color_schemes",
	},
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	enable_tab_bar = true,
	font = wezterm.font_with_fallback({ "Iosevka Extended" }),
	keys = keys,
	line_height = 1.1,
	ssh_domains = ssh_domains,
}
