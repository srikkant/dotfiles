local utils = require("srikkant.utils")
local harpoon = require("harpoon")
local pickers = require("mini.extra").pickers

vim.keymap.set("n", "U", "<cmd>redo<cr>", utils.opts("Redo tree"))

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

vim.keymap.set("n", "<leader>w", "<C-w>", utils.opts("Window operations"))

vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", utils.opts("Code action"))
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", utils.opts("Hover doc"))
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", utils.opts("Open float diagnostic"))

vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>", utils.opts("Rename symbol"))
vim.keymap.set("n", "<leader>x", "<cmd>TroubleToggle<cr>", utils.opts("Toggle trouble"))
vim.keymap.set("n", "<leader>e", "<cmd>TroubleToggle document_diagnostics<cr>", utils.opts("Document diagnostics"))
vim.keymap.set("n", "<leader>E", "<cmd>TroubleToggle workspace_diagnostics<cr>", utils.opts("Workspace diagnostics"))
vim.keymap.set("n", "<leader>L", "<cmd>TroubleToggle loclist<cr>", utils.opts("Toggle loclist"))
vim.keymap.set("n", "<leader>Q", "<cmd>TroubleToggle quickfix<cr>", utils.opts("Toggle quickfix"))

vim.keymap.set("n", "gd", "<cmd>TroubleToggle lsp_definitions<cr>", utils.opts("Show LSP definitions"))
vim.keymap.set("n", "gD", "<cmd>TroubleToggle lsp_type_definitions<cr>", utils.opts("Show LSP type definitions"))
vim.keymap.set("n", "gi", "<cmd>TroubleToggle lsp_implementations<cr>", utils.opts("Show LSP Implementations"))
vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<cr>", utils.opts("Show LSP references"))

vim.keymap.set("n", "<leader>b", "<cmd>Pick buffers<cr>", utils.opts("Pick buffers"))
vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>", utils.opts("Pick files"))
vim.keymap.set("n", "<leader>'", "<cmd>Pick resume<cr>", utils.opts("Resume last picker"))
vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", utils.opts("Live search"))

vim.keymap.set("n", "'", utils.toggle_files_explorer, utils.opts("Show explorer"))
vim.keymap.set("n", "<leader>'", utils.toggle_files_explorer_cwd, utils.opts("Show explorer (CWD)"))

vim.keymap.set("n", "<leader>h", function() require("mini.extra").pickers.keymaps() end, utils.opts("Show keymaps"))
vim.keymap.set("n", "<leader>S", function() pickers.lsp({ scope = "workspace_symbol" }) end, utils.opts("Work symbols"))
vim.keymap.set("n", "<leader>s", function() pickers.lsp({ scope = "document_symbol" }) end, utils.opts("Symbols"))

vim.keymap.set("n", "<leader>1", function() require("dap").continue() end, utils.opts("Debug: Continue"))
vim.keymap.set("n", "<leader>2", function() require("dap").step_over() end, utils.opts("Debug: Stepover"))
vim.keymap.set("n", "<leader>3", function() require("dap").step_into() end, utils.opts("Debug: Step into"))
vim.keymap.set("n", "<leader>4", function() require("dap").step_out() end, utils.opts("Debug: Step out"))
vim.keymap.set("n", "<Leader>qb", function() require("dap").toggle_breakpoint() end, utils.opts("Debug: Breakpoint"))
vim.keymap.set("n", "<Leader>qB", function() require("dap").set_breakpoint() end, utils.opts("Debug: Set breakpoint"))

vim.keymap.set("n", "<Leader>qr", function() require("dap").repl.open() end, utils.opts("Debug: Open REPL"))
vim.keymap.set("n", "<Leader>ql", function() require("dap").run_last() end, utils.opts("Debug: Run last"))
vim.keymap.set({ "n", "v" }, "<Leader>qK", function() require("dapui").eval() end, utils.opts("Debug: Eval"))
vim.keymap.set({ "n", "v" }, "<Leader>qo", function() require("dapui").toggle() end, utils.opts("Debug: Toggle UI"))

vim.keymap.set("n", "<leader>j", function() harpoon:list():add() end, utils.opts("Haroon: Add"))
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, utils.opts("Harpoon: Menu"))
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, utils.opts("Harpoon: Goto 1"))
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, utils.opts("Harpoon: Goto 2"))
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, utils.opts("Harpoon: Goto 3"))
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, utils.opts("Harpoon: Goto 4"))
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, utils.opts("Harpoon: Goto next"))
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, utils.opts("Harpoon: Goto prev"))
