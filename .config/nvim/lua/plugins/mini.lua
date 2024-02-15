return {
    {
        "echasnovski/mini.nvim",
        lazy = false,
        version = "*",
        keys = {
            {
                "-",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
                end,
                desc = "Open mini.files (directory of current file)",
            },
            {
                "<leader>-",
                function()
                    require("mini.files").open(vim.loop.cwd(), true)
                end,
                desc = "Open mini.files (cwd)",
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

            local show_dotfiles = true
            local filter_show = function(_)
                return true
            end
            local filter_hide = function(fs_entry)
                return not vim.startswith(fs_entry.name, ".")
            end

            local toggle_dotfiles = function()
                show_dotfiles = not show_dotfiles
                local new_filter = show_dotfiles and filter_show or filter_hide
                require("mini.files").refresh({ content = { filter = new_filter } })
            end

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesBufferCreate",
                callback = function(args)
                    local buf_id = args.data.buf_id
                    -- Tweak left-hand side of mapping to your liking
                    vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
                end,
            })

            require("mini.files").setup({
                content = {
                    prefix = function() end,
                },
                windows = {
                    width_focus = 50,
                    width_nofocus = 10,
                    width_preview = 40,
                    preview = true,
                },
            })
        end,
    },
}
