local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path })
    vim.cmd("packadd mini.nvim | helptags ALL")
end

vim.opt.completeopt = "menuone,noselect"
vim.opt.expandtab = true
vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.wo.relativenumber = true

local deps = require("mini.deps")
deps.setup()

local add = deps.add
add("folke/lazydev.nvim")
add("rose-pine/neovim")
add("nvim-lua/plenary.nvim")
add("kevinhwang91/promise-async")
add("kevinhwang91/nvim-ufo")
add("neovim/nvim-lspconfig")
add("VonHeikemen/lsp-zero.nvim")
add("williamboman/mason.nvim")
add("williamboman/mason-lspconfig.nvim")
add("hrsh7th/nvim-cmp")
add("hrsh7th/cmp-nvim-lsp")
add("hrsh7th/cmp-path")
add("folke/trouble.nvim")
add("mfussenegger/nvim-lint")
add("nvim-treesitter/nvim-treesitter")
add("andrewferrier/debugprint.nvim")
add("stevearc/conform.nvim")
add("github/copilot.vim")

require("lazydev").setup()
require("rose-pine").setup({ styles = { italic = false, transparency = true } })
vim.cmd([[colorscheme rose-pine]])

require("ufo").setup()
require("debugprint").setup()
require("mason").setup()

require("mini.basics").setup({})
require("mini.comment").setup({})
require("mini.icons").setup({})
require("mini.bracketed").setup({})
require("mini.diff").setup({})
require("mini.git").setup({})
require("mini.indentscope").setup({})
require("mini.surround").setup({})
require("mini.pick").setup({})

local files = require("mini.files")
files.setup({})

require("nvim-treesitter.configs").setup({
    modules = {},
    ensure_installed = {},
    ignore_install = {},
    auto_install = true,
    sync_install = false,
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

--
-- LSP, completions, linting, formatting & other IDE stuff.
--
local mason_lspconfig = require("mason-lspconfig")
local cmp = require("cmp")
local lsp_zero = require("lsp-zero")

lsp_zero.extend_lspconfig({ capabilities = require("cmp_nvim_lsp").default_capabilities() })
mason_lspconfig.setup({ handlers = { lsp_zero.default_setup } })
cmp.setup({
    sources = { { name = "nvim_lsp" }, { name = "path" } },
    window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
    snippet = { expand = function(args) vim.snippet.expand(args.body) end },
    mapping = cmp.mapping.preset.insert({}),
})

require("trouble").setup()

local lint = require("lint")
lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    md = { "markdownlint" },
    mdx = { "markdownlint" },
}

local conform = require("conform")

conform.setup({
    format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
    },
    format_after_save = {
        lsp_fallback = true,
    },
    formatters_by_ft = {
        go = { "goimports" },
        lua = { "stylua" },
        css = { "prettierd" },
        scss = { "prettierd" },
        javascript = { "injected", "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        html = { "injected", "prettierd" },
        sql = { "sql_formatter" },
        templ = { "injected", "templ", lsp_format = "never" },
    },
    formatters = {
        injected = {
            options = {
                ignore_errors = true,
                lang_to_formatters = {
                    javascript = { "prettierd" },
                    html = { "prettierd" },
                    templ = { "templ" },
                },
            },
        },
    },
})

---
--- Keymaps
---
local key = vim.keymap.set

key({ "n", "v" }, "<leader>y", [["+y]])
key({ "n", "v" }, "<leader>d", [["_d]])
key("n", "=", [[<cmd>vertical resize +5<cr>]])
key("n", "-", [[<cmd>vertical resize -5<cr>]])
key("n", "+", [[<cmd>horizontal resize +2<cr>]])
key("n", "_", [[<cmd>horizontal resize -2<cr>]])
key("n", "gb", "<cmd>Pick buffers<cr>")
key("n", "gf", "<cmd>Pick files<cr>")
key("n", "g;", "<cmd>Pick resume<cr>")
key("n", "g/", "<cmd>Pick grep_live<cr>")
key("n", "gc", "<cmd>Trouble lsp toggle focus=true<cr>")
key("n", "ge", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>")
key("n", "gE", "<cmd>Trouble diagnostics toggle focus=true<cr>")
key("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>")
key("n", "gD", "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>")
key("n", "gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>")
key("n", "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>")
key("n", "gs", "<cmd>Trouble symbols toggle focus=true<cr>")
key("n", "'", function() files.open((vim.api.nvim_buf_get_name(0)), true) end)
key("n", "cd", vim.lsp.buf.rename)
key({ "n", "v" }, "g.", vim.lsp.buf.code_action)

--
-- Auto commands
--
local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufWritePre" }, { pattern = "*", callback = function(args) conform.format({ bufnr = args.buf }) end })
autocmd({ "BufWritePost" }, { callback = function() lint.try_lint(nil, { ignore_errors = true }) end })
autocmd({ "InsertLeave", "TextChanged" }, { callback = function() lint.try_lint(nil, { ignore_errors = true }) end })
