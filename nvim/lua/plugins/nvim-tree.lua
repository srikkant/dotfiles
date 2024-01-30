return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                disable_netrw = true,
                hijack_netrw = true,
                update_focused_file = {
                    enable = true,
                },
            })
        end,
        keys = {
            { "\\", "<cmd>NvimTreeToggle<cr>", desc = "Toggle tree" },
            { "|", "<cmd>NvimTreeFocus<cr>", desc = "Focus tree" },
        },
    },
}
