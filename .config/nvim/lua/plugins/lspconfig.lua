return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "VonHeikemen/lsp-zero.nvim",
            "folke/trouble.nvim",
        },
        keys = {
            { "K", "<cmd>lua vim.lsp.buf.hover()<cr>" },
            { "gl", "<cmd>lua vim.diagnostic.open_float()<cr>" },
            { "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>" },
            { "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>" },
            { "<leader>e", "<cmd>TroubleToggle document_diagnostics<cr>" },
            { "<leader>E", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
            { "<leader>L", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
            { "<leader>Q", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
            { "gd", "<cmd>TroubleToggle lsp_definitions<cr>", desc = "Open definitions (Trouble)" },
            { "gD", "<cmd>TroubleToggle lsp_type_definitions<cr>", desc = "Open type definitions (Trouble)" },
            { "gi", "<cmd>TroubleToggle lsp_implementations<cr>", desc = "Open implementations (Trouble)" },
            { "gr", "<cmd>TroubleToggle lsp_references<cr>", desc = "Open references (Trouble)" },
        },
        config = function()
            local signs = { Error = " •", Warn = " •", Hint = " •", Info = " •" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            local lsp_zero = require("lsp-zero")

            lsp_zero.set_server_config({
                capabilities = {
                    textDocument = {
                        foldingRange = {
                            dynamicRegistration = false,
                            lineFoldingOnly = true,
                        },
                    },
                },
            })

            require("trouble").setup({
                icons = false,
                use_diagnostic_signs = true,
                fold_open = "-",
                fold_closed = "+",
            })

            require("mason").setup()
            require("mason-lspconfig").setup({
                handlers = {
                    lsp_zero.default_setup,
                },
            })

            require("ufo").setup()
        end,
    },
}
