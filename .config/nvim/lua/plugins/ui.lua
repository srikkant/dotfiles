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
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                transparent = true,
                theme = "wave",
            })
        end,
    },
}
