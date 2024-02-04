return {
	"nvim-tree/nvim-web-devicons",
	{
		"nvimdev/indentmini.nvim",
		event = "BufEnter",
		config = function()
			require("indentmini").setup({ char = "│" })
			vim.cmd.highlight("default link IndentLine Comment")
		end,
	},
	{
		"folke/which-key.nvim",
		opts = {},
	},
}
