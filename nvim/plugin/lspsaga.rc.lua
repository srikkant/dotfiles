local status, saga = pcall(require, "lspsaga")
if not status then
	return
end

local keymap = vim.keymap.set

saga.init_lsp_saga()

-- Uses the default float window, used rarely in case the error is too big and not showing up anywhere.
keymap("n", "gi", vim.lsp.buf.implementation, { silent = true })

-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Go to Definition
keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")

-- Show line diagnostic
keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

-- Show cursor diagnostic
keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

-- Show buffer diagnostic
keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

keymap("n", "<leader>st", vim.diagnostic.open_float, { silent = true })

-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
keymap("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", { silent = true })

keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

-- Hover Doc
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
