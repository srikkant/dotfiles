return {
    { "tpope/vim-sleuth" },
    {
        "nvimdev/indentmini.nvim",
        config = function()
            require("indentmini").setup({ char = "│" })
            vim.cmd.highlight("default link IndentLine Comment")
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
        },
    },
}
