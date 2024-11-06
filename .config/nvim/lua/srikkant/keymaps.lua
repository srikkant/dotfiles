local utils = require("srikkant.utils")
local pickers = require("mini.extra").pickers

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], utils.opts("Copy to system clipboard"))
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], utils.opts("Delete into oblivion"))

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]], utils.opts("Vertical Resize +")) -- make the window bigger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]], utils.opts("Vertical Resize -")) -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], utils.opts("Horizontal Resize +")) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], utils.opts("Horizontal Resize -")) -- make the window smaller horizontally by pressing shift and
vim.keymap.set("n", "cd", "<cmd>lua vim.lsp.buf.rename()<cr>", utils.opts("Rename symbol"))

vim.keymap.set({ "n", "v" }, "g.", "<cmd>lua vim.lsp.buf.code_action()<cr>", utils.opts("Code action"))
vim.keymap.set("n", "gc", "<cmd>Trouble lsp toggle focus=true<cr>", utils.opts("LSP definitions"))
vim.keymap.set("n", "ge", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>", utils.opts("Doc diags"))
vim.keymap.set("n", "gE", "<cmd>Trouble diagnostics toggle focus=true<cr>", utils.opts("Workspace diags"))
vim.keymap.set("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>", utils.opts("LSP definitions"))
vim.keymap.set("n", "gD", "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>", utils.opts("LSP type definitions"))
vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>", utils.opts("LSP Implementations"))
vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>", utils.opts("Show LSP references"))
vim.keymap.set("n", "gb", "<cmd>Pick buffers<cr>", utils.opts("Pick buffers"))
vim.keymap.set("n", "gf", "<cmd>Pick files<cr>", utils.opts("Pick files"))
vim.keymap.set("n", "g;", "<cmd>Pick resume<cr>", utils.opts("Resume last picker"))
vim.keymap.set("n", "g/", "<cmd>Pick grep_live<cr>", utils.opts("Live search"))
vim.keymap.set("n", "gS", function() pickers.lsp({ scope = "workspace_symbol" }) end, utils.opts("Work symbols"))
vim.keymap.set("n", "gs", function() pickers.lsp({ scope = "document_symbol" }) end, utils.opts("Symbols"))

vim.keymap.set("n", "'", utils.toggle_files_explorer, utils.opts("Show explorer"))
vim.keymap.set("n", "<leader>'", utils.toggle_files_explorer_cwd, utils.opts("Show explorer (CWD)"))

vim.keymap.set("n", "<leader>h", function() pickers.keymaps() end, utils.opts("Show keymaps"))
