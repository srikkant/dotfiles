return {
	"nvim-lualine/lualine.nvim",
	after = "nvimdev/lspsaga.nvim",
	config = function()
		local colors = require("tokyonight.colors").setup({ transform = true })
		local custom_theme = require("lualine.themes.tokyonight")

		custom_theme.normal = {
			a = { bg = "#00000000", fg = colors.fg_sidebar },
			b = { bg = "#00000000", fg = colors.fg_sidebar },
			c = { bg = "#00000000", fg = colors.fg_sidebar },
		}

		custom_theme.insert = {
			a = { bg = "#00000000", fg = colors.green },
		}

		custom_theme.visual = {
			a = { bg = "#00000000", fg = colors.magenta },
			b = { bg = "#00000000", fg = colors.magenta },
		}

		custom_theme.command = {
			a = { bg = "#00000000", fg = colors.yellow },
			b = { bg = "#00000000", fg = colors.fg_gutter },
		}

		custom_theme.replace = {
			a = { bg = "#00000000", fg = colors.blue },
			b = { bg = "#00000000", fg = colors.fg_gutter },
		}

		custom_theme.inactive = {
			a = { bg = "#00000000", fg = colors.fg_gutter },
			b = { bg = "#00000000", fg = colors.fg_gutter },
			c = { bg = "#00000000", fg = colors.fg_gutter },
		}

		require("lualine").setup({
			options = {
				icons_enabled = false,
				theme = custom_theme,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "filename" },
				lualine_c = {
					{
						"diagnostics",
						symbols = { error = "󰅚 ", warn = "󰀪 ", hint = "󰌶 ", info = " " },
					},
				},
				lualine_x = { "filetype" },
				lualine_y = { "location" },
				lualine_z = { "tabs" },
			},
		})
	end,
}
