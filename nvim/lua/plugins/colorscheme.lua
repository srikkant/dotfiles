return {
    {
        "navarasu/onedark.nvim",
        lazy = true,
        priority = 1000,
        config = function()
            require("onedark").load({
                style = "darker",
            })
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "onedark",
        },
    },
}
