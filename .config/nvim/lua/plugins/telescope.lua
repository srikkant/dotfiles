return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    dependencies = {
        "folke/trouble.nvim",
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        local trouble = require("trouble.providers.telescope")
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                mappings = {
                    i = { ["<c-t>"] = trouble.open_with_trouble },
                    n = { ["<c-t>"] = trouble.open_with_trouble },
                },
            },
        })
        require("telescope").load_extension("fzf")
    end,
    keys = {

        {
            "<leader>v",
            "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
            desc = "Open file browser",
        },

        {
            "<leader>b",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "List buffers",
        },
        {
            "<leader>g",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "Live grep",
        },
        {
            "<leader>f",
            function()
                require("telescope.builtin").find_files()
            end,
            desc = "List files",
        },
        {
            "<leader>'",
            function()
                require("telescope.builtin").resume()
            end,
            desc = "Reopen last picker",
        },
        {
            "<leader>S",
            function()
                require("telescope.builtin").lsp_workspace_symbols()
            end,
            desc = "Show workspace symbols",
        },
        {
            "<leader>s",
            function()
                require("telescope.builtin").lsp_document_symbols()
            end,
            desc = "Show document symbols",
        },
        {
            "<leader>/",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "Search",
        },
    },
}
