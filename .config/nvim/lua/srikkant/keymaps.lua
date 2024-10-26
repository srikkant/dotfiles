local utils = require("srikkant.utils")
local pickers = require("mini.extra").pickers

vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", utils.opts("Next tab"))
vim.keymap.set("n", "<leader>tp", "<cmd>tabprev<CR>", utils.opts("Previous tab"))
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", utils.opts("New Tab"))
vim.keymap.set("n", "<leader>td", "<cmd>tabclose<CR>", utils.opts("Close tab"))

-- greatest remap ever: theprimeagen
vim.keymap.set("x", "<leader>p", [["_dP]], utils.opts("Paste from system clipboard"))
vim.keymap.set("n", "<leader>Y", [["+Y]], utils.opts("Copy to system clipboard"))
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], utils.opts("Copy to system clipboard"))
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], utils.opts("Delete into oblivion"))

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]], utils.opts("Vertical Resize +")) -- make the window bigger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]], utils.opts("Vertical Resize -")) -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], utils.opts("Horizontal Resize +")) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], utils.opts("Horizontal Resize -")) -- make the window smaller horizontally by pressing shift and

vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", utils.opts("Code action"))

vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>", utils.opts("Rename symbol"))

vim.keymap.set("n", "<leader>e", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>", utils.opts("Doc diags"))
vim.keymap.set("n", "<leader>E", "<cmd>Trouble diagnostics toggle focus=true<cr>", utils.opts("Workspace diags"))
vim.keymap.set("n", "<leader>L", "<cmd>Trouble loclist toggle focus=true<cr>", utils.opts("Toggle loclist"))
vim.keymap.set("n", "<leader>Q", "<cmd>Trouble qflist toggle focus=true<cr>", utils.opts("Toggle quickfix"))
vim.keymap.set("n", "<leader>c", "<cmd>Trouble lsp toggle focus=true<cr>", utils.opts("LSP definitions"))

vim.keymap.set("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>", utils.opts("LSP definitions"))
vim.keymap.set("n", "gD", "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>", utils.opts("LSP type definitions"))
vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>", utils.opts("LSP Implementations"))
vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>", utils.opts("Show LSP references"))

vim.keymap.set("n", "<leader>b", "<cmd>Pick buffers<cr>", utils.opts("Pick buffers"))
vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>", utils.opts("Pick files"))
vim.keymap.set("n", "<leader>;", "<cmd>Pick resume<cr>", utils.opts("Resume last picker"))
vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", utils.opts("Live search"))

vim.keymap.set("n", "'", utils.toggle_files_explorer, utils.opts("Show explorer"))
vim.keymap.set("n", "<leader>'", utils.toggle_files_explorer_cwd, utils.opts("Show explorer (CWD)"))

vim.keymap.set("n", "<leader>h", function() pickers.keymaps() end, utils.opts("Show keymaps"))
vim.keymap.set("n", "<leader>S", function() pickers.lsp({ scope = "workspace_symbol" }) end, utils.opts("Work symbols"))
vim.keymap.set("n", "<leader>s", function() pickers.lsp({ scope = "document_symbol" }) end, utils.opts("Symbols"))
