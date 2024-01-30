return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
            "pmizio/typescript-tools.nvim",
        },
        config = function()
            require("neodev").setup({})

            require("mason").setup()
            require("mason-lspconfig").setup()
            require("lspconfig").lua_ls.setup({})
            require("lspconfig").rust_analyzer.setup({})
            require("typescript-tools").setup({})

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
            })

            local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end,
    },
}
