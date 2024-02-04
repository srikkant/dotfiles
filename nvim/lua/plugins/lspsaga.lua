return {
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		after = "nvim-lspconfig",
		opts = {
			symbol_in_winbar = {
				enable = false,
				show_file = false,
			},
			ui = {
				sign = false,
			},
		},
		keys = {
			{
				"<leader>a",
				"<cmd>Lspsaga code_action<cr>",
				desc = "Show code actions",
				mode = { "n", "v" },
			},
			{ "<leader>r", "<cmd>Lspsaga rename<cr>", desc = "Rename symbol" },
			{ "<leader>k", "<cmd>Lspsaga hover_doc<cr>", desc = "Show Hover doc" },
			{ "gp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
			{ "gP", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek type definition" },
			{ "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Go to definition" },
			{ "gD", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Go to type definition" },
			{ "gi", "<cmd>Lspsaga incoming_calls<cr>", desc = "Incoming calls" },
			{ "go", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Outgoing calls" },
			{ "gr", "<cmd>Lspsaga finder<cr>", desc = "Open references" },
			{
				"[E",
				function()
					require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end,
				desc = "Jump to previous error",
			},
			{
				"]E",
				function()
					require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
				end,
				desc = "Jump to next error",
			},
			{
				"[e",
				function()
					require("lspsaga.diagnostic"):goto_prev()
				end,
				desc = "Jump to prev diagnostic",
			},
			{
				"]e",
				function()
					require("lspsaga.diagnostic"):goto_prev()
				end,
				desc = "Jump to next diagnostic",
			},
		},
	},
}
