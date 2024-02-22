local augroup = vim.api.nvim_create_augroup("Formatting", {})

return {
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    go = { "goimports" },
                    lua = { "stylua" },
                    css = { "prettierd" },
                    scss = { "prettierd" },
                    javascript = { "prettierd" },
                    javascriptreact = { "prettierd" },
                    typescript = { "prettierd" },
                    typescriptreact = { "prettierd" },
                    json = { "prettierd" },
                    yaml = { "prettierd" },
                },
                format_on_save = {
                    lsp_fallback = true,
                },
                notify_on_error = true,
            })

            -- create an autocmd to format on save.
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                group = augroup,
                callback = function(args)
                    require("conform").format({ bufnr = args.buf })
                end,
            })
        end,
    },
}
