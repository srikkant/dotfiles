local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldenable = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.relativenumber = true

require("lazy").setup({
    spec = {
        { "nvim-lua/plenary.nvim" },
        {
            "rose-pine/neovim",
            name = "rose-pine",
            config = function()
                require("rose-pine").setup({ styles = { italic = false, transparency = true } })
                vim.cmd("colorscheme rose-pine")
            end,
        },
        { "andrewferrier/debugprint.nvim", opts = {} },
        {
            "folke/trouble.nvim",
            opts = {},
            keys = {
                { "ge", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>" },
                { "gE", "<cmd>Trouble diagnostics toggle focus=true<cr>" },
                { "gc", "<cmd>Trouble lsp toggle focus=true<cr>" },
                { "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>" },
                { "gD", "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>" },
                { "gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>" },
                { "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>" },
                { "gs", "<cmd>Trouble symbols toggle focus=true<cr>" },
            },
        },
        {
            "neovim/nvim-lspconfig",
            lazy = false,
            config = function()
                for _, lsp in ipairs({ "cssls", "eslint", "html", "ts_ls", "gopls", "templ" }) do
                    require("lspconfig")[lsp].setup({})
                end
            end,
            keys = {
                { "cd", vim.lsp.buf.rename },
                { "g.", vim.lsp.buf.code_action, mode = { "n", "v" } },
            },
        },
        {
            "ibhagwan/fzf-lua",
            keys = {
                { "gb", "<cmd>FzfLua buffers<cr>" },
                { "gf", "<cmd>FzfLua files<cr>" },
                { "g;", "<cmd>FzfLua resume<cr>" },
                { "g/", "<cmd>FzfLua live_grep<cr>" },
            },
        },
        {
            "stevearc/oil.nvim",
            opts = {},
            keys = {
                { "'", "<CMD>Oil<CR>" },
            },
        },
        {
            "echasnovski/mini.nvim",
            lazy = false,
            config = function()
                require("mini.icons").setup({})
                require("mini.basics").setup({})
                require("mini.completion").setup({})
                require("mini.diff").setup({})
                require("mini.git").setup({})
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            config = function()
                require("nvim-treesitter.configs").setup({
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "]x",
                            scope_incremental = "]X",
                            node_incremental = "]x",
                            node_decremental = "[x",
                        },
                    },
                })
            end,
        },
        {
            "nvimtools/none-ls.nvim",
            config = function()
                local null_ls = require("null-ls")
                null_ls.setup({
                    sources = {
                        null_ls.builtins.formatting.goimports,
                        null_ls.builtins.formatting.prettierd,
                        null_ls.builtins.formatting.stylua,
                        null_ls.builtins.formatting.sql_formatter,
                    },
                })
            end,
        },
    },
})

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]])
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]])
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]])
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.api.nvim_create_autocmd("BufWritePre", { buffer = bufnr, callback = function() vim.lsp.buf.format() end })
