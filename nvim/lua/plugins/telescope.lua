return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    opts = {
        extensions = {
            file_browser = {
                theme = "ivy",
                -- disables netrw and use telescope-file-browser in its place
                hijack_netrw = false,
                mappings = {
                    ["i"] = {
                        -- your custom insert mode mappings
                    },
                    ["n"] = {
                        -- your custom normal mode mappings
                    },
                },
            },
        },
    },
    config = function(opts)
        require("telescope").setup(opts)
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
            "<leader>d",
            function()
                require("telescope.builtin").diagnostics({ bufnr = 0 })
            end,
            desc = "Open diagnostics",
        },
        {
            "<leader>D",
            function()
                require("telescope.builtin").diagnostics()
            end,
            desc = "Open workspace diagnostics",
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
