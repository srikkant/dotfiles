local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

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
vim.opt.completeopt = "menuone,noinsert,noselect"

require("lazy").setup({
    spec = {
        {
            "ellisonleao/gruvbox.nvim",
            config = function()
                require("gruvbox").setup({ transparent_mode = true, contrast = "soft" })
                vim.cmd([[colorscheme gruvbox]])
            end,
        },
        {
            "folke/snacks.nvim",
            dependencies = {
                "echasnovski/mini.icons",
            },
            keys = {
                { "<leader>z", function() Snacks.picker.marks() end },
                { "<leader>q", function() Snacks.picker.qflist() end },
                { "<leader>l", function() Snacks.picker.loclist() end },
                { "<leader>j", function() Snacks.picker.jumps() end },
                { "<leader>b", function() Snacks.picker.buffers() end },
                { "<leader>f", function() Snacks.picker.files() end },
                { "<leader>;", function() Snacks.picker.resume() end },
                { "<leader>/", function() Snacks.picker.grep() end },
                { "<leader>s", function() Snacks.picker.lsp_symbols() end },
                { "<leader>S", function() Snacks.picker.lsp_workspace_symbols() end },
                { "<leader>e", function() Snacks.picker.diagnostics_buffer() end },
                { "<leader>E", function() Snacks.picker.diagnostics() end },
                { "<leader>d", function() Snacks.picker.lsp_definitions() end },
                { "<leader>D", function() Snacks.picker.lsp_declarations() end },
                { "<leader>i", function() Snacks.picker.lsp_implementations() end },
                { "<leader>r", function() Snacks.picker.lsp_references() end },
                { "<leader>h", function() Snacks.picker.help() end },
            },
        },
        {
            "saghen/blink.cmp",
            version = "0.11.0",
            opts = {
                completion = {
                    menu = {
                        auto_show = false,
                    },
                },
                keymap = {
                    ["<C-s>"] = { "show" },
                },
            },
        },
        {
            "pmizio/typescript-tools.nvim",
            dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
            opts = {},
        },
        {
            "neovim/nvim-lspconfig",
            lazy = false,
            opts = {
                servers = {
                    cssls = {},
                    eslint = {},
                    html = {},
                    gopls = {},
                    rust_analyzer = {},
                    clangd = {},
                },
            },
            keys = {
                { "<C-h>", function() vim.diagnostic.open_float() end },
                { "<C-k>", function() vim.lsp.buf.signature_help() end },
                { "cd", function() vim.lsp.buf.rename() end },
                { "<leader>.", function() vim.lsp.buf.code_action() end, mode = { "n", "v" } },
            },
            config = function(_, opts)
                local blink = require("blink.cmp")
                local lspconfig = require("lspconfig")
                for server, config in pairs(opts.servers) do
                    config.capabilities = blink.get_lsp_capabilities(config.capabilities)
                    lspconfig[server].setup(config)
                end

                blink.setup({})
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            config = function()
                require("nvim-treesitter.configs").setup({
                    auto_install = true,
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = true },
                    incremental_selection = { enable = true },
                })
            end,
        },
        {
            "stevearc/conform.nvim",
            opts = {
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    javascript = { "prettierd" },
                    typescript = { "prettierd" },
                    javacriptreact = { "prettierd" },
                    typescriptreact = { "prettierd" },
                    go = { "goimports" },
                    cpp = { "clang-format" },
                    bzl = { "buildifier" },
                    sql = { "sql_formatter" },
                },
            },
        },
        {
            "stevearc/oil.nvim",
            lazy = false,
            opts = {},
            keys = {
                { "-", "<CMD>Oil<CR>" },
            },
        },
    },
})

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])

local MeGroup = vim.api.nvim_create_augroup("Me", {})
vim.api.nvim_create_autocmd(
    "TextYankPost",
    { group = MeGroup, pattern = "*", callback = function() vim.highlight.on_yank() end }
)
