local augroup = vim.api.nvim_create_augroup("Linting", {})

return {
    {
        "mfussenegger/nvim-lint",
        lazy = false,
        config = function()
            require("lint").linters_by_ft = {
                javascript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescript = { "eslint_d" },
                typescriptreact = { "eslint_d" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                group = augroup,
                callback = function()
                    require("lint").try_lint()
                end,
            })

            vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
                group = augroup,
                pattern = { "*.tsx", "*.ts", "*.js", "*.jsx" },
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
