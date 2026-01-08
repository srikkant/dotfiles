local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

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

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])
vim.keymap.set("n", "-", "<cmd>Explore<cr>")

vim.api.nvim_create_autocmd("TextYankPost", { pattern = "*", callback = function() vim.highlight.on_yank() end })

require("lazy").setup({
    spec = {
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {},
        },
        {
            "xiyaowong/transparent.nvim",
            config = function()
                require("transparent").setup()
                vim.g.transparent_enabled = true
            end,
        },
        {
            "p00f/alabaster.nvim",
            config = function()
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
                vim.cmd("colorscheme alabaster")
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            opts = {},
        },
        {
            "saghen/blink.cmp",
            version = "1.*",
            opts = {},
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                local on_attach = function(client, bufnr)
                    if client and client:supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function() vim.lsp.buf.format({ bufnr = bufnr, async = false }) end,
                        })
                    end
                end


                vim.lsp.config("*", { on_attach = on_attach })
                vim.lsp.config("clangd", { filetypes = { "c", "cpp" }, on_attach = on_attach })
                vim.lsp.config("gdscript", { on_attach = on_attach })
                vim.lsp.config("ts_ls", { on_attach = on_attach })

                vim.lsp.enable("lua_ls")
                vim.lsp.enable("ts_ls")
                vim.lsp.enable("html")
                vim.lsp.enable("clangd")
                vim.lsp.enable("gopls")
                vim.lsp.enable("protols")
                vim.lsp.enable("gdscript")
            end,
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
        {
            "stevearc/conform.nvim",
            opts = {},
            config = function()
                require("conform").setup({
                    formatters_by_ft = {
                        javascript = { "prettierd", "prettier", stop_after_first = true },
                        typescript = { "prettierd", "prettier", stop_after_first = true },
                        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                    },
                })

                vim.api.nvim_create_autocmd("BufWritePre", {
                    pattern = "*",
                    callback = function(args)
                        require("conform").format({ bufnr = args.buf })
                    end,
                })
            end,
        },
        {
            "supermaven-inc/supermaven-nvim",
            config = function()
                require("supermaven-nvim").setup({})
            end,
        },
    },
})
