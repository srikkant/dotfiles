local status, packer = pcall(require, "packer")
if not status then
	print("Packer is not installed!")
	return
end

vim.cmd([[packadd packer.nvim]])

packer.startup(function(use)
	-- package manager.
	-- absolutely essential
	use("wbthomason/packer.nvim")

	-- mason is used for managing external tools
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- general UI enhancements!
	-- refer to the inline comment for more information.
	use("nvim-lualine/lualine.nvim") -- Statusline
	use("nvim-lua/plenary.nvim") -- Common utilities
	use("onsails/lspkind-nvim") -- vscode-like pictograms
	use("hrsh7th/cmp-buffer") -- nvim-cmp source for buffer words
	use("hrsh7th/cmp-nvim-lsp") -- nvim-cmp source for neovim's built-in LSP
	use("hrsh7th/nvim-cmp") -- Completion
	use("neovim/nvim-lspconfig") -- LSP
	use("jose-elias-alvarez/null-ls.nvim") -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
	use("MunifTanjim/prettier.nvim") -- Prettier plugin for Neovim's built-in LSP client
	use("glepnir/lspsaga.nvim") -- LSP UIs
	use("L3MON4D3/LuaSnip")
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")
	use("norcalli/nvim-colorizer.lua")
	use("akinsho/nvim-bufferline.lua")
	use("kyazdani42/nvim-web-devicons")
	use("winston0410/commented.nvim")
	use("ggandor/leap.nvim")

	-- git related features!
	-- For git blame & browse
	use("lewis6991/gitsigns.nvim")
	use("dinhhuy258/git.nvim")

	use("akinsho/flutter-tools.nvim")
	use("jose-elias-alvarez/typescript.nvim")

	-- themes and more!
	use("atelierbram/Base2Tone-nvim")
	use("sainnhe/everforest")

	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})

	-- Packer
	use({
		"folke/noice.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	})

	use({
		"tzachar/cmp-tabnine",
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
	})
end)
