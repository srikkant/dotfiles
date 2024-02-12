return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        lazy = true,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({})
        end,
        keys = {
            {
                "<leader>q",
                function()
                    require("harpoon"):list():append()
                end,
                desc = "Harpoon",
            },
            {
                "<leader>Q",
                function()
                    require("harpoon"):list():remove()
                end,
                desc = "Remove Harpoon",
            },
            {
                "<leader>A",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "List Harpooned",
            },
        },
    },
}
