local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_keepdir = 0

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

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])

vim.api.nvim_create_autocmd("TextYankPost", { pattern = "*", callback = function() vim.highlight.on_yank() end })

require("lazy").setup({
    spec = {
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {},
        },
        {
            'maxmx03/solarized.nvim',
            lazy = false,
            opts = {
                transparent = { enabled = true },
            },
            config = function(_, opts)
                vim.o.termguicolors = true
                require('solarized').setup(opts)
                vim.cmd.colorscheme 'solarized'
            end,
        },
        {
            "f-person/auto-dark-mode.nvim",
            opts = {}
        },
        {
            "nvim-treesitter/nvim-treesitter",
            opts = {}
        },
        {
            "stevearc/oil.nvim",
            opts = { default_file_explorer = true },
            dependencies = { "echasnovski/mini.icons" },
            keys = {
                { "-", "<cmd>Oil<cr>" }
            }
        },
        {
            "saghen/blink.cmp",
            version = "1.*",
            opts = {}
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                vim.lsp.config('*', {
                    on_attach = function(client, bufnr)
                        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
                        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })

                        if client and client:supports_method('textDocument/formatting') then
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function() vim.lsp.buf.format({ bufnr = bufnr, async = false }) end,
                            })
                        end
                    end
                })

                vim.lsp.enable("lua_ls")
                vim.lsp.enable("ts_ls")
                vim.lsp.enable("gopls")
                vim.lsp.enable("protols")
                vim.lsp.enable("html")
            end
        },
        {
            "folke/snacks.nvim",
            dependencies = {
                "echasnovski/mini.icons",
            },
            keys = {
                { "<leader>b", function() require("snacks").picker.buffers() end },
                { "<leader>f", function() require("snacks").picker.files() end },
                { "<leader>;", function() require("snacks").picker.resume() end },
                { "<leader>/", function() require("snacks").picker.grep() end },
                { "<leader>h", function() require("snacks").picker.help() end },
            },
        },
        {
            "folke/trouble.nvim",
            opts = { focus = true, auto_jump = true },
            cmd = "Trouble",
            keys = {
                { "<leader>E",  "<cmd>Trouble diagnostics toggle<cr>", },
                { "<leader>e",  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" },
                { "<leader>xl", "<cmd>Trouble loclist toggle<cr>" },
                { "<leader>xq", "<cmd>Trouble qflist toggle<cr>" },
                { "gd",         "<cmd>Trouble lsp_definitions toggle<cr>" },
                { "grr",        "<cmd>Trouble lsp_references toggle<cr>" },
            },
        },
        { "github/copilot.vim" },
        {
            "yetone/avante.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
            },
            build = function()
                if vim.fn.has("win32") == 1 then
                    return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
                else
                    return "make"
                end
            end,
            version = false,
            event = "VeryLazy",
            opts = {
                provider = "copilot",
            },
        },
    },
})
