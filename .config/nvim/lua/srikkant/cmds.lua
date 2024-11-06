local lintGroup = vim.api.nvim_create_augroup("Linting", {})
local formatGroup = vim.api.nvim_create_augroup("Formatting", {})

local lint = require("lint")
local conform = require("conform")

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*",
    group = formatGroup,
    callback = function(args) conform.format({ bufnr = args.buf }) end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = lintGroup,
    callback = function() lint.try_lint() end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    group = lintGroup,
    pattern = { "*.tsx", "*.ts", "*.js", "*.jsx" },
    callback = function() lint.try_lint() end,
})
