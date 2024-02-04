return {
	{
		"kevinhwang91/nvim-ufo",
		lazy = false,
		dependencies = {
			"kevinhwang91/promise-async",
		},
		after = "nvim-lspconfig",
		keys = {
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
			{

				"zK",
				function()
					local winid = require("ufo").peekFoldedLinesUnderCursor()
					if not winid then
						vim.lsp.buf.hover()
					end
				end,
				desc = "Peek fold",
			},
		},
	},
}
