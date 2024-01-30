return {
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        after = "nvim-lspconfig",
        opts = {},
        keys = {
            { "<leader>r", "<cmd>Lspsaga rename<cr>", desc = "Rename symbol" },
            { "<leader>a", "<cmd>Lspsaga code_action<cr>", desc = "Show code actions" },
            { "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Go to definitions" },
            { "gD", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Go to type definition" },
            { "gr", "<cmd>Lspsaga finder<cr>", desc = "Open references" },
            { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Show Hover doc" },
            {
                "[E",
                function()
                    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
                end,
                desc = "Jump to previous error",
            },
            {
                "]E",
                function()
                    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
                end,
                desc = "Jump to next error",
            },
            {
                "[e",
                function()
                    require("lspsaga.diagnostic"):goto_prev()
                end,
                desc = "Jump to prev diagnostic",
            },
            {
                "]e",
                function()
                    require("lspsaga.diagnostic"):goto_prev()
                end,
                desc = "Jump to next diagnostic",
            },
        },
    },
}
