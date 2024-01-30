return {
    {
        "echasnovski/mini.nvim",
        lazy = false,
        version = "*",
        keys = {
            {
                "<leader>e",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
                end,
                desc = "Open mini.files (directory of current file)",
            },
            {
                "<leader>E",
                function()
                    require("mini.files").open(vim.loop.cwd(), true)
                end,
                desc = "Open mini.files (cwd)",
            },
        },
        config = function()
            require("mini.pairs").setup({})

            require("mini.surround").setup({
                mappings = {
                    add = "gza",            -- Add surrounding in Normal and Visual modes
                    delete = "gzd",         -- Delete surrounding
                    find = "gzf",           -- Find surrounding (to the right)
                    find_left = "gzF",      -- Find surrounding (to the left)
                    highlight = "gzh",      -- Highlight surrounding
                    replace = "gzr",        -- Replace surrounding
                    update_n_lines = "gzn", -- Update `n_lines`
                },
            })

            require("mini.starter").setup({})

            require("mini.files").setup({
                windows = {
                    preview = true,
                },
            })

            require("mini.basics").setup({
                {
                    options = {
                        basic = true,
                        extra_ui = false,
                        win_borders = "default",
                    },
                    mappings = {
                        basic = false,
                        windows = false,
                        move_with_alt = false,
                    },
                    autocommands = {
                        basic = true,
                    },
                },
            })
        end,
    },
}
