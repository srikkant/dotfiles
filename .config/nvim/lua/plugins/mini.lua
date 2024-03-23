local minifiles_toggle = function(...)
    local MiniFiles = require("mini.files")
    if not MiniFiles.close() then
        MiniFiles.open(...)
    end
end

return {
    {
        "echasnovski/mini.nvim",
        lazy = false,
        version = "*",
        keys = {
            {
                "'",
                function()
                    minifiles_toggle(vim.api.nvim_buf_get_name(0), true)
                end,
            },
            {
                "<leader>'",
                function()
                    minifiles_toggle(vim.loop.cwd(), true)
                end,
            },
            {
                "<leader>b",
                function()
                    require("mini.pick").builtin.buffers()
                end,
            },
            {
                "<leader>f",
                function()
                    require("mini.pick").builtin.files()
                end,
            },
            {
                "<leader>'",
                function()
                    require("mini.pick").builtin.resume()
                end,
            },
            {
                "<leader>S",
                function()
                    require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
                end,
            },
            {
                "<leader>s",
                function()
                    require("mini.extra").pickers.lsp({ scope = "document_symbol" })
                end,
            },
            {
                "<leader>/",
                function()
                    require("mini.pick").builtin.grep_live()
                end,
            },
        },
        config = function()
            require("mini.pairs").setup({})
            require("mini.comment").setup({})

            require("mini.surround").setup({
                mappings = {
                    add = "gsa", -- Add surrounding in Normal and Visual modes
                    delete = "gsd", -- Delete surrounding
                    find = "gsf", -- Find surrounding (to the right)
                    find_left = "gsF", -- Find surrounding (to the left)
                    highlight = "gsh", -- Highlight surrounding
                    replace = "gsr", -- Replace surrounding
                    update_n_lines = "gsn", -- Update `n_lines`
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

            require("mini.files").setup({
                content = {
                    prefix = function() end,
                },
                windows = {
                    max_number = 3,
                    width_focus = 50,
                    width_nofocus = 40,
                    width_preview = 80,
                    preview = true,
                },
            })

            require("mini.pick").setup({
                source = { show = require("mini.pick").default_show },
            })

            require("mini.indentscope").setup({
                draw = {
                    animation = require("mini.indentscope").gen_animation.none(),
                },
            })

            require("mini.extra").setup({})
        end,
    },
}
