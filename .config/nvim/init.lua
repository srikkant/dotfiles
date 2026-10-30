vim.g.mapleader = " "
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.fillchars = "eob: "
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.completeopt = "menuone,noselect,popup"
vim.opt.wrap = false
vim.opt.wildmode = "longest:full,full"

vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/dchinmay2/alabaster.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

vim.cmd.colorscheme("alabaster")

require("conform").setup({
    formatters_by_ft = {
        markdown = { "oxfmt" },
        typescript = { "oxfmt" },
        javascript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        json = { "oxfmt" },
        yaml = { "oxfmt" },
        go = { "goimports" },
        gomod = { "goimports" },
        odin = { "odinfmt" }
    },
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

vim.lsp.config("tsc", {
    cmd = { "bunx", "tsc", "--lsp", "--stdio" },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_markers = { "tsconfig.json", "package.json", "bun.lockb", "bun.lock", ".git" },
})

vim.lsp.config("oxlint", {
    cmd = { "oxlint", "--lsp" },
    root_markers = { ".oxlintrc.json", "oxlint.json", "package.json", ".git" },
    on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", "stylua.toml", ".git" },
    filetypes = { "lua" },
    settings = {
        Lua = {
            codeLens = { enable = true },
            hint = { enable = true, semicolon = "Disable" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
        },
    },
})

vim.lsp.config("ols", {
    cmd = { "ols" },
    filetypes = { "odin" },
    root_markers = { ".ols.json", ".git", "*.odin" },
    init_options = {
        checker_args = "-strict-style",
    }
})

vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go" },
    root_markers = { "go.mod", ".git", "*.go" },
})

vim.lsp.enable("tsc")
vim.lsp.enable("oxlint")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ols")
vim.lsp.enable("gopls")

local Snacks = require("snacks")

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])
vim.keymap.set("n", "-", "<cmd>Ex<cr>")
vim.keymap.set("n", "<leader>cm", "<cmd>make<cr>")
vim.keymap.set("n", "<leader>cc", "<cmd>make<cr>")
vim.keymap.set("n", "<leader>cr", "<cmd>make run<cr>")

vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.smart() end)
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end)
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end)
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end)
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end)
vim.keymap.set("n", "<leader>'", function() Snacks.picker.resume() end)
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end)
vim.keymap.set("n", "grr", function() Snacks.picker.lsp_references() end)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        if client:supports_method("textDocument/completion", args.buf) then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "odin",
    callback = function()
        vim.bo.errorformat = "%f:%l:%c: %m"
    end,
})


vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true })
