return {
    { "tpope/vim-sleuth" },
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
