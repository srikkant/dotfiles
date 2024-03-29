local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"

if not vim.loop.fs_stat(mini_path) then
    vim.fn.system("git", "clone --filter=blob:none https://github.com/echasnovski/mini.nvim " .. mini_path)
    vim.cmd("packadd mini.nvim | helptags ALL")
end

local deps = require("mini.deps")

deps.setup()

deps.add("rebelot/kanagawa.nvim")
deps.add("lewis6991/gitsigns.nvim")
deps.add("kevinhwang91/nvim-ufo")
deps.add("kevinhwang91/promise-async")
deps.add("neovim/nvim-lspconfig")
deps.add("williamboman/mason.nvim")
deps.add("williamboman/mason-lspconfig.nvim")
deps.add("VonHeikemen/lsp-zero.nvim")
deps.add("folke/trouble.nvim")
deps.add("mfussenegger/nvim-lint")
deps.add("hrsh7th/nvim-cmp")
deps.add("hrsh7th/cmp-nvim-lsp")
deps.add("hrsh7th/cmp-path")
deps.add("Exafunction/codeium.nvim")
deps.add("nvim-lua/plenary.nvim")
deps.add("stevearc/conform.nvim")
deps.add("folke/neodev.nvim")
deps.add("nvim-treesitter/nvim-treesitter")

local utils = require("utils")

local kanagawa = require("kanagawa")
local gitsigns = require("gitsigns")
local ufo = require("ufo")
local lsp_zero = require("lsp-zero")
local trouble = require("trouble")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lint = require("lint")
local cmp = require("cmp")
local codeium = require("codeium")
local conform = require("conform")
local basics = require("mini.basics")
local comment = require("mini.comment")
local extra = require("mini.extra")
local files = require("mini.files")
local indentscope = require("mini.indentscope")
local pairs = require("mini.pairs")
local pick = require("mini.pick")
local statusline = require("mini.statusline")
local surround = require("mini.surround")
local neodev = require("neodev")
local treesitter_configs = require("nvim-treesitter.configs")

--
-- Autocomplete for neovim APIs.
-- This is just used for configuration here.
--
neodev.setup()

--
-- Some essential pure UI plugins
--
gitsigns.setup()
ufo.setup()

--
-- Kanagawa theme
--
kanagawa.setup()

treesitter_configs.setup({
    auto_install = true,
    sync_install = false,
    ensure_installed = {},
    ignore_install = {},
    modules = {},
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<M-space>",
        },
    },
})

lsp_zero.set_server_config({
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    },
})

mason.setup()

codeium.setup()

mason_lspconfig.setup({
    handlers = { lsp_zero.default_setup },
})

trouble.setup({
    icons = false,
    use_diagnostic_signs = true,
    cycle_results = false,
    fold_open = "-",
    fold_closed = "+",
    signs = { other = "•" },
})

cmp.setup({
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "codeium" },
    },
})

lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    md = { "markdownlint" },
    mdx = { "markdownlint" },
}
conform.setup({
    formatters_by_ft = {
        go = { "goimports" },
        lua = { "stylua" },
        css = { "prettierd" },
        scss = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
    },
    format_on_save = {
        lsp_fallback = true,
    },
    notify_on_error = true,
})

--
--
-- Mini.nvim stack of plugins
--
--
basics.setup({})
comment.setup({})
extra.setup({})
pairs.setup({})
surround.setup({})

pick.setup({
    source = {
        show = pick.default_show,
    },
})

indentscope.setup({
    draw = {
        animation = indentscope.gen_animation.none(),
    },
})

files.setup({
    content = { prefix = function() end },
    windows = { max_number = 3, width_focus = 50, width_nofocus = 40, width_preview = 80, preview = true },
})

statusline.setup({
    use_icons = false,
    content = {
        active = function()
            local groups = {}
            local mode = statusline.section_mode({ trunc_width = 120 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local diagnostics = utils.get_diagnostics()

            table.insert(groups, { strings = { mode }, hl = "StatuslineMode" })
            for _, d in ipairs(diagnostics) do
                table.insert(groups, d)
            end

            -- Add file name & position
            table.insert(groups, { strings = { filename }, hl = "StatuslineFile" })
            table.insert(groups, "%=")
            table.insert(groups, { strings = { "%2v:%l" } })

            return statusline.combine_groups(groups)
        end,
        inactive = function()
            local filename = statusline.section_filename({ trunc_width = 140 })
            return statusline.combine_groups({
                { hl = "StatuslineFile", strings = { filename } },
            })
        end,
    },
})
