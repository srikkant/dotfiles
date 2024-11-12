local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path })
    vim.cmd("packadd mini.nvim | helptags ALL")
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.completeopt = "menuone,noselect"
vim.opt.expandtab = true
vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.mouse = ""
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

-- indirect dependencies
deps.add("nvim-lua/plenary.nvim")
deps.add("nvim-neotest/nvim-nio")

deps.add("kevinhwang91/promise-async")
deps.add("kevinhwang91/nvim-ufo")
deps.add("neovim/nvim-lspconfig")
deps.add("williamboman/mason.nvim")
deps.add("williamboman/mason-lspconfig.nvim")
deps.add({ source = "VonHeikemen/lsp-zero.nvim", checkout = "v4.x" })
deps.add("folke/trouble.nvim")
deps.add("mfussenegger/nvim-lint")
deps.add("hrsh7th/nvim-cmp")
deps.add("hrsh7th/cmp-nvim-lsp")
deps.add("hrsh7th/cmp-path")
deps.add("github/copilot.vim")
deps.add("nvim-treesitter/nvim-treesitter")
deps.add("rose-pine/neovim")
deps.add("andrewferrier/debugprint.nvim")
deps.add("mfussenegger/nvim-dap")
deps.add("leoluz/nvim-dap-go")
deps.add("stevearc/conform.nvim")
deps.add("stevearc/oil.nvim")

local colorscheme = require("rose-pine")
local ufo = require("ufo")
local lsp_zero = require("lsp-zero")
local trouble = require("trouble")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lint = require("lint")
local cmp = require("cmp")
local conform = require("conform")
local basics = require("mini.basics")
local bracketed = require("mini.bracketed")
local comment = require("mini.comment")
local pairs = require("mini.pairs")
local pick = require("mini.pick")
local git = require("mini.git")
local diff = require("mini.diff")
local icons = require("mini.icons")
local indentscope = require("mini.indentscope")
local surround = require("mini.surround")
local treesitter_configs = require("nvim-treesitter.configs")
local debugprint = require("debugprint")
local oil = require("oil")

local lintGroup = vim.api.nvim_create_augroup("Linting", {})

colorscheme.setup({ styles = { italic = false, transparency = true } })
vim.cmd([[colorscheme rose-pine]])

ufo.setup()
debugprint.setup()
basics.setup({})
comment.setup({})
icons.setup({})
pairs.setup({})
pick.setup({})
bracketed.setup({})
diff.setup({})
git.setup({})
indentscope.setup({})
surround.setup({})
oil.setup({})

--
-- Treesitter configurations
--
treesitter_configs.setup({
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
lsp_zero.extend_lspconfig({ capabilities = require("cmp_nvim_lsp").default_capabilities() })
trouble.setup()
mason.setup()
mason_lspconfig.setup({ handlers = { lsp_zero.default_setup } })

cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "copilot" },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    snippet = {
        expand = function(args) vim.snippet.expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({}),
})

lint.linters = {
    eslint_d = {
        args = {
            "--no-warn-ignored",
            "--format",
            "json",
            "--stdin",
            "--stdin-filename",
            function() return vim.api.nvim_buf_get_name(0) end,
        },
    },
}

lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    md = { "markdownlint" },
    mdx = { "markdownlint" },
}

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
})

conform.formatters.injected = {
    options = {
        ignore_errors = true,
        lang_to_formatters = {
            javascript = { "prettierd" },
            html = { "prettierd" },
            templ = { "templ" },
        },
    },
}

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*",
    group = lintGroup,
    callback = function(args) conform.format({ bufnr = args.buf }) end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = lintGroup,
    callback = function() lint.try_lint(nil, { ignore_errors = true }) end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    group = lintGroup,
    pattern = { "*.tsx", "*.ts", "*.js", "*.jsx" },
    callback = function() lint.try_lint() end,
})

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]])
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]])
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]])
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]])

vim.keymap.set("n", "cd", vim.lsp.buf.rename)
vim.keymap.set({ "n", "v" }, "g.", vim.lsp.buf.code_action)

vim.keymap.set("n", "gc", "<cmd>Trouble lsp toggle focus=true<cr>")
vim.keymap.set("n", "ge", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>")
vim.keymap.set("n", "gE", "<cmd>Trouble diagnostics toggle focus=true<cr>")
vim.keymap.set("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>")
vim.keymap.set("n", "gD", "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>")
vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>")
vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>")
vim.keymap.set("n", "gs", "<cmd>Trouble symbols toggle focus=true<cr>")

vim.keymap.set("n", "gb", "<cmd>Pick bufferscr>")
vim.keymap.set("n", "gf", "<cmd>Pick files<cr>")
vim.keymap.set("n", "g;", "<cmd>Pick resume<cr>")
vim.keymap.set("n", "g/", "<cmd>Pick grep_live<cr>")
vim.keymap.set("n", "'", "<cmd>Oil<cr>")
