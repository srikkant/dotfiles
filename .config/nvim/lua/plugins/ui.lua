return {
    { "tpope/vim-sleuth" },
    {
        "nvimdev/indentmini.nvim",
        config = function()
            require("indentmini").setup({ char = "│" })
            vim.cmd.highlight("default link IndentLine Comment")
        end,
    },
}
