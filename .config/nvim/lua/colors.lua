-- I like things a very specific & minimal way, so some custom highlight groups specifically.
--
-- Diagnostics colors from kanagawa.nvim
-- @todo: Check if we can import it directly.
-- samuraiRed = "#E82424",
-- roninYellow = "#FF9E3B",
-- waveAqua1 = "#6A9589",
-- dragonBlue = "#658594",

vim.api.nvim_set_hl(0, "StatuslineDiagnosticError", { fg = "#E82424" })
vim.api.nvim_set_hl(0, "StatuslineDiagnosticWarn", { fg = "#FF9E3B" })
vim.api.nvim_set_hl(0, "StatuslineDiagnosticInfo", { fg = "#6A9589" })
vim.api.nvim_set_hl(0, "StatuslineDiagnosticHint", { fg = "#658594" })
vim.api.nvim_set_hl(0, "StatuslineFile", { fg = "#4d4d4d" })
vim.api.nvim_set_hl(0, "StatuslineMode", { fg = "#cccccc" })

local signs = { Error = " •", Warn = " •", Hint = " •", Info = " •" }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Finally set my color scheme!
vim.cmd([[colorscheme kanagawa]])
