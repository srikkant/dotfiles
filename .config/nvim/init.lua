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
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/supermaven-inc/supermaven-nvim" },
    { src = "https://github.com/rose-pine/neovim",              name = "rose-pine" },
})

require("fzf-lua").setup()
require("supermaven-nvim").setup({})

require("rose-pine").setup({
    variant = "auto",
    styles = {
        bold = false,
        italic = false,
        transparency = true,
    },
    highlight_groups = {
        DiagnosticUnderlineError = { undercurl = true, sp = "love" },
        DiagnosticUnderlineWarn  = { undercurl = true, sp = "gold" },
        DiagnosticUnderlineInfo  = { undercurl = true, sp = "foam" },
        DiagnosticUnderlineHint  = { undercurl = true, sp = "iris" },
        SpellBad                 = { undercurl = true, sp = "love" },
    }
})

vim.cmd("colorscheme rose-pine")

vim.lsp.config("tsc", {
    cmd = { "tsc", "--lsp", "--stdio" },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_markers = { "tsconfig.json", "package.json", "bun.lockb", "bun.lock", ".git" },
})

vim.lsp.config("oxfmt", {
    cmd = { "oxfmt", "--lsp" },
    root_markers = { ".oxlintrc.json", "oxlint.json", "package.json", ".git" },
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

vim.lsp.enable("tsc")
vim.lsp.enable("oxlint")
vim.lsp.enable("oxfmt")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ols")

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])
vim.keymap.set("n", "-", "<cmd>Ex<cr>")
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>cm", ":make ")
vim.keymap.set("n", "<leader>cc", "<cmd>make<cr>")
vim.keymap.set("n", "<leader>cr", "<cmd>make run<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua global<cr>")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        if client:supports_method("textDocument/completion", args.buf) then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        if client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ id = client.id })
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "odin",
    callback = function()
        vim.bo.errorformat = "%f:%l:%c: %m"
    end,
})

-- Temporary fix: for neovim 0.12
local og_glob = vim.glob.to_lpeg
vim.glob.to_lpeg = function(pattern)
    if type(pattern) == "string" then
        pattern = pattern:gsub("bundled:///", "")
        pattern = pattern:gsub("%*%*%*", "**")
    end

    local status, result = pcall(og_glob, pattern)
    if not status then
        return og_glob("")
    end
    return result
end
