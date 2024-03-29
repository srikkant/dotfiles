local opts = { noremap = true, silent = true }
local utils = require("utils")

vim.keymap.set("n", "U", "<cmd>redo<cr>", opts)

vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", opts)
vim.keymap.set("n", "<leader>tp", "<cmd>tabprev<CR>", opts)
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", opts)
vim.keymap.set("n", "<leader>td", "<cmd>tabclose<CR>", opts)

-- greatest remap ever: theprimeagen
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window bigger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and

vim.keymap.set("n", "<leader>w", "<C-w>", opts)

vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>")
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")

vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>")
vim.keymap.set("n", "<leader>x", "<cmd>TroubleToggle<cr>")
vim.keymap.set("n", "<leader>e", "<cmd>TroubleToggle document_diagnostics<cr>")
vim.keymap.set("n", "<leader>E", "<cmd>TroubleToggle workspace_diagnostics<cr>")
vim.keymap.set("n", "<leader>L", "<cmd>TroubleToggle loclist<cr>")
vim.keymap.set("n", "<leader>Q", "<cmd>TroubleToggle quickfix<cr>")

vim.keymap.set("n", "gd", "<cmd>TroubleToggle lsp_definitions<cr>")
vim.keymap.set("n", "gD", "<cmd>TroubleToggle lsp_type_definitions<cr>")
vim.keymap.set("n", "gi", "<cmd>TroubleToggle lsp_implementations<cr>")
vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<cr>")

vim.keymap.set("n", "<leader>b", "<cmd>Pick buffers<cr>")
vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>")
vim.keymap.set("n", "<leader>'", "<cmd>Pick resume<cr>")
vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>")

vim.keymap.set("n", "'", utils.toggle_files_explorer)
vim.keymap.set("n", "<leader>'", utils.toggle_files_explorer_cwd)

vim.keymap.set("n", "<leader>h", function()
    require("mini.extra").pickers.keymaps()
end)

vim.keymap.set("n", "<leader>S", function()
    require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
end)

vim.keymap.set("n", "<leader>s", function()
    require("mini.extra").pickers.lsp({ scope = "document_symbol" })
end)
