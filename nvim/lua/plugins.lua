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

	-- Common utilities
	use("nvim-lua/plenary.nvim")
	use("lewis6991/impatient.nvim")

	-- Tresitter for syntax highlighting.
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	-- mason is used for managing external tools
	-- this includes all the language servers we are planning on using
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- Language server related plugins
	use("neovim/nvim-lspconfig")
	use("jose-elias-alvarez/null-ls.nvim")

	-- Snippet engine
	use("L3MON4D3/LuaSnip")

	-- Completion and Snippets related plugins
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer") -- nvim-cmp source for buffer words
	use("hrsh7th/cmp-nvim-lsp") -- nvim-cmp source for neovim's built-in LSP
	use("tzachar/cmp-tabnine") -- nvim-cmp source for TabNine completions
	use("saadparwaiz1/cmp_luasnip") -- nvim-cmp source for Snippets powered by lua snip

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use("nvim-telescope/telescope-ui-select.nvim")
	use("jvgrootveld/telescope-zoxide")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- UI enhancements
	use("goolord/alpha-nvim")
	use("nvim-tree/nvim-tree.lua")
	use("glepnir/lspsaga.nvim") -- LSP UIs
	use("onsails/lspkind-nvim") -- vscode-like pictograms
	use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use("nvim-lualine/lualine.nvim") -- Lualine
	use("akinsho/nvim-bufferline.lua") -- Bufferline for the tabs on top
	use("folke/which-key.nvim")

	-- general enhancements!
	use("norcalli/nvim-colorizer.lua")
	use("kyazdani42/nvim-web-devicons")
	use("winston0410/commented.nvim")
	use("ggandor/leap.nvim")
	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")
	use("chentoast/marks.nvim")

	-- Git related plugins
	use("lewis6991/gitsigns.nvim")
	use("dinhhuy258/git.nvim")

	-- Language/Framework specific tooling
	use("jose-elias-alvarez/typescript.nvim")
	use("mrjones2014/legendary.nvim")

	-- themes and more!
	use("gpanders/editorconfig.nvim")
	use("ellisonleao/gruvbox.nvim")
	use("folke/tokyonight.nvim")
end)
