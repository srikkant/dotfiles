vim.g.netrw_sort_sequence = "[\\/]$"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldenable = false
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.fillchars = "eob: "
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true
vim.opt.completeopt = "menuone,noselect,popup"
vim.opt.termguicolors = true

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])
vim.keymap.set("n", "-", "<cmd>Explore<cr>")

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function() vim.highlight.on_yank() end,
})

return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {},
    },
    {
        "f-person/auto-dark-mode.nvim",
        opts = {}
    },
    { 
        "xiyaowong/transparent.nvim",
        config = function()
            require("transparent").setup();
            vim.g.transparent_enabled = true;
        end
    },
    {
        "p00f/alabaster.nvim",
        config = function(_, opts)
            vim.cmd.colorscheme("alabaster")
        end,
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {},
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        keys = {
            { "<leader>b", function() require("telescope.builtin").buffers() end },
            { "<leader>f", function() require("telescope.builtin").find_files() end },
            { "<leader>;", function() require("telescope.builtin").resume() end },
            { "<leader>/", function() require("telescope.builtin").live_grep() end },
            { "<leader>h", function() require("telescope.builtin").help_tags() end },
            { "<leader>e", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end },
            { "<leader>E", function() require("telescope.builtin").diagnostics() end },
            { "<leader>l", function() require("telescope.builtin").loclist() end },
            { "<leader>q", function() require("telescope.builtin").quickfix() end },
            { "<leader>j", function() require("telescope.builtin").jumplist() end },
            { "<leader>s", function() require("telescope.builtin").symbols() end },
            { "grr",       function() require("telescope.builtin").lsp_references() end },
            { "gd",        function() require("telescope.builtin").lsp_definitions() end },
            { "gD",        function() require("telescope.builtin").lsp_type_definitions() end },
        },
    },
}
