local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return {
    {
        "nvimtools/none-ls.nvim",
        opts = function()
            local null_ls = require("null-ls")
            return {
                sources = {
                    null_ls.builtins.diagnostics.eslint_d,
                    null_ls.builtins.formatting.eslint_d,
                    null_ls.builtins.formatting.goimports,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.code_actions.eslint_d,
                    null_ls.builtins.code_actions.refactoring,
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ async = false })
                            end,
                        })
                    end
                end,
            }
        end,
    },
}
