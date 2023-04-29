return { -- add telescope-fzf-native
    {
        "telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
                config = function()
                    require("telescope").load_extension("file_browser")
                end,
            },
        },
        init = function()
            require("telescope").load_extension("flutter")
        end,
        keys = {
            {
                "<leader><leader>",
                function()
                    require("telescope.builtin").resume()
                end,
            },
            {
                "<leader>fd",
                function()
                    require("telescope").extensions.flutter.commands()
                end,
                desc = "Flutter Tools (Flutter projects)",
            },
            {
                "<leader>fb",
                function()
                    require("telescope").extensions.file_browser.file_browser({
                        path = "%:p:h",
                        cwd = vim.fn.expand("%:p:h"),
                        respect_gitignore = false,
                        hidden = true,
                        grouped = true,
                        theme = "ivy",
                        initial_mode = "normal",
                    })
                end,
                desc = "Open file browser",
            },
        },
    },
}
