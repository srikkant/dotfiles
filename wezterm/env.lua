local module = {}
local status, _env = pcall(require, ".envgen")
local wezterm = require "wezterm"

local function init_key(envKey, default_value)
	local value = os.getenv(envKey) or default_value;
	if status then
		value = _env[envKey] or value;
	end
	return value
end

-- add the required environment initialization here with default values.
module["appearance"] = init_key("TERMINAL_APPEARANCE", wezterm.gui.get_appearance())
module["font_size"] = tonumber(init_key("TERMINAL_FONT_SIZE", 12))
module["cell_width"] = tonumber(init_key("TERMINAL_CELL_SPACING", 1))
module["line_height"] = tonumber(init_key("TERMINAL_LINE_HEIGHT", 1.4))

return module
