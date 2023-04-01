return {
    -- add oxocarbon
    { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = true, priority = 1000 },
    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "moonfly",
        },
    },
}
