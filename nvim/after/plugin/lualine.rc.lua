local status, lualine = pcall(require, "lualine")
if not status then
	return
end

lualine.setup({
	theme = "tokyonight-night",
	options = {
		icons_enabled = true,
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{
				"filename",
				file_status = true,
				path = 1,
			},
		},
		lualine_c = {},
		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
			},
			"filetype",
		},
		lualine_y = { "branch" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			},
		},
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "fugitive" },
})
