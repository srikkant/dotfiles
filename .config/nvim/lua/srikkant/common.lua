return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local on_attach = function(client, bufnr)
                if client and client:supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function() vim.lsp.buf.format({ bufnr = bufnr, async = false }) end,
                    })
                end
            end


            vim.lsp.config("lua_ls", { on_attach = on_attach })
            vim.lsp.config("clangd", { filetypes = { "c", "cpp" }, on_attach = on_attach })

            vim.lsp.enable("lua_ls")
            vim.lsp.enable("clangd")
            vim.lsp.enable("protols")
        end,
    }
}
