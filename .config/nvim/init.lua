local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/nvim-mini/mini.nvim", mini_path })
    vim.cmd("packadd mini.nvim | helptags ALL")
end

vim.g.mapleader = " "
vim.g.netrw_sort_sequence = "[\\/]$"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
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

vim.api.nvim_create_autocmd("TextYankPost", { pattern = "*", callback = function() vim.highlight.on_yank() end })

require("mini.deps").setup()

local deps = require("mini.deps");
deps.setup()

deps.add("folke/lazydev.nvim")
deps.add("xiyaowong/transparent.nvim")
deps.add("p00f/alabaster.nvim")
deps.add("nvim-treesitter/nvim-treesitter")
deps.add("neovim/nvim-lspconfig")
deps.add("creativenull/efmls-configs-nvim")
deps.add("supermaven-inc/supermaven-nvim")
deps.add("folke/trouble.nvim")

require("lazydev").setup()
require("transparent").setup()
require("supermaven-nvim").setup({})
require("mini.completion").setup()
require("mini.snippets").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("trouble").setup()

local files = require("mini.files")
local pick = require("mini.pick")
local extra = require("mini.extra")

files.setup()
pick.setup()
extra.setup()

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "alabaster",
    callback = function()
        for _, group in ipairs({ "Underlined", "DiagnosticUnderlineError", "DiagnosticUnderlineWarn", "DiagnosticUnderlineInfo", "DiagnosticUnderlineHint" }) do
            local gui = vim.api.nvim_get_hl(0, { name = group })
            vim.api.nvim_set_hl(0, group, {
                undercurl = true,
                sp = gui.sp or gui.fg
            })
        end
    end,
})

vim.g.transparent_enabled = true
vim.cmd("colorscheme alabaster")

local on_attach = function(client, bufnr)
    if client and client:supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ bufnr = bufnr, async = false }) end,
        })
    end
end

local eslintd_lint = require("efmls-configs.linters.eslint_d")
local eslintd_format = require("efmls-configs.formatters.eslint_d")
local prettierd = require("efmls-configs.formatters.prettier_d")
local languages = {
    javascript = { eslintd_lint, eslintd_format, prettierd },
    typescript = { eslintd_lint, eslintd_format, prettierd },
    typescriptreact = { eslintd_lint, eslintd_format, prettierd },
    javascriptreact = { eslintd_lint, eslintd_format, prettierd },
}

local efmls_config = {
    filetypes = vim.tbl_keys(languages),
    settings = {
        rootMarkers = { ".git/" },
        languages = languages,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
}

vim.lsp.config("*", { on_attach = on_attach })
vim.lsp.config("clangd", { filetypes = { "c", "cpp" }, on_attach = on_attach })
vim.lsp.config("gdscript", { on_attach = on_attach })
vim.lsp.config("ts_ls", { on_attach = on_attach })
vim.lsp.config("rust_analyzer", { on_attach = on_attach })
vim.lsp.config("efm",
    vim.tbl_extend("force", efmls_config, { cmd = { "efm-langserver" }, on_attach = on_attach }))

vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("html")
vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("protols")
vim.lsp.enable("gdscript")
vim.lsp.enable("efm")

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])
vim.keymap.set("n", "-", function() files.open() end)
vim.keymap.set("n", "<leader>fb", function() pick.builtin.buffers() end)
vim.keymap.set("n", "<leader>ff", function() pick.builtin.files() end)
vim.keymap.set("n", "<leader>;", function() pick.builtin.resume() end)
vim.keymap.set("n", "<leader>/", function() pick.builtin.grep_live() end)
vim.keymap.set("n", "<leader>fh", function() pick.builtin.help() end)
vim.keymap.set("n", "<leader>cx", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>")
vim.keymap.set("n", "<leader>cX", "<cmd>Trouble diagnostics toggle focus=true<cr>")
vim.keymap.set("n", "<leader>fs", "<cmd>Trouble symbols toggle focus=true<cr>")
vim.keymap.set("n", "grr", "<cmd>Trouble lsp_references toggle focus=true<cr>")
vim.keymap.set("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>")
vim.keymap.set("n", "gD", "<cmd>Trouble lsp_declarations toggle focus=true<cr>")
