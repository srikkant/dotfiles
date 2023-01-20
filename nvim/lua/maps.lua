local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Some simple ways to get back to normal mode.
keymap.set("i", "kj", "<Esc>")
keymap.set("i", "jk", "<Esc>")

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- Move window
keymap.set("n", "st", "<C-w>w")
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sl", "<C-w>l", opts)

-- Resize window
keymap.set("n", "<C-k>", ":resize +2<CR>", opts)
keymap.set("n", "<C-j>", ":resize -2<CR>", opts)
keymap.set("n", "<C-l>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-h>", ":vertical resize +2<CR>", opts)

-- Improvements to paste/delete.
keymap.set("n", "<leader>d", '"_d', opts)
keymap.set("n", "<leader>p", '"_dP', opts)

--
-- Lspsaga related keymaps.
--

-- Uses the default float window, used rarely in case the error is too big and not showing up anywhere.
keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

-- Lsp finder find the symbol definition implement reference
keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)

-- Code action
keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)

-- Rename
keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", opts)

-- Peek Definition
keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)

-- Go to Definition
keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<CR>")

-- Show line diagnostic
keymap.set("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

-- Show cursor diagnostic
keymap.set("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

-- Show buffer diagnostic
keymap.set("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

-- Open the diagnostic in a separate float in case we need it
keymap.set("n", "<leader>st", vim.diagnostic.open_float, opts)

-- Diagnsotic jump can use `<c-o>` to jump back
keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)

-- Only jump to error
keymap.set("n", "[E", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap.set("n", "]E", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)

keymap.set("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
keymap.set("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

-- Hover Doc
keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)

--
-- Keymaps related to trouble.nvim
--
keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts)
keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", opts)
keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", opts)
keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", opts)

--
-- Nvim tree toggle
--
keymap.set("n", "<Leader>b", ":NvimTreeToggle<CR>", opts)

--
-- Debugger
-- 

keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", opts)
keymap.set("n", "<leader>dc", "<cmd>DapContinue<cr>", opts)
keymap.set("n", "<leader>ds", "<cmd>DapStepOver<cr>", opts)
keymap.set("n", "<leader>di", "<cmd>DapStepInto<cr>", opts)
keymap.set("n", "<leader>do", "<cmd>DapStepOut<cr>", opts)
keymap.set("n", "<leader>db", "<cmd>DapContinue<cr>", opts)
keymap.set("n", "<leader>dt", "<cmd>DapTerminate<cr>", opts)
keymap.set("n", "<leader>ds", "<cmd>DapLoadLaunchJSON<cr>", opts)
keymap.set("n", "<leader>dll", "<cmd>DapShowLog<cr>", opts)

--
-- 
--
