return {
	"nvim-lualine/lualine.nvim",
	after = "nvimdev/lspsaga.nvim",
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = false,
				theme = "auto",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						"diagnostics",
						symbols = { error = "󰅚 ", warn = "󰀪 ", hint = "󰌶 ", info = " " },
					},
				},
				lualine_c = { "filename" },
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location", "tabs" },
			},
			tabline = {
				lualine_a = {
					require("lspsaga.symbol.winbar").get_bar,
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
