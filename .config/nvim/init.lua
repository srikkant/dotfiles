local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path })
    vim.cmd("packadd mini.nvim | helptags ALL")
end

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldenable = false
vim.opt.undofile = true
vim.opt.relativenumber = true

local deps = require("mini.deps")
deps.setup()

deps.add({ source = "nvim-lua/plenary.nvim" })
deps.add({ source = "ellisonleao/gruvbox.nvim" })
deps.add({ source = "neovim/nvim-lspconfig" })
deps.add({ source = "nvim-treesitter/nvim-treesitter" })
deps.add({ source = "nvimtools/none-ls.nvim" })
deps.add({ source = "saghen/blink.cmp", checkout = "v0.7.6" })

require("gruvbox").setup({ transparent_mode = true, contrast = "soft" })

require("mini.basics").setup({})
require("mini.icons").setup({})
require("mini.bracketed").setup({})
require("mini.diff").setup({})
require("mini.git").setup({})
require("mini.files").setup({})
require("mini.pick").setup({})
require("mini.extra").setup({})

require("nvim-treesitter.configs").setup({
    auto_install = true,
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = { init_selection = "]x", scope_incremental = "]X", node_incremental = "]x", node_decremental = "[x" },
    },
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

for _, lsp in ipairs({ "cssls", "eslint", "html", "ts_ls", "gopls", "rust_analyzer", "clangd", "qmlls" }) do
    require("lspconfig")[lsp].setup({ capabilities = capabilities })
end

require("blink.cmp").setup()

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.sql_formatter,
        null_ls.builtins.formatting.buildifier,
        null_ls.builtins.diagnostics.buildifier,
    },
})

vim.cmd([[colorscheme gruvbox]])
vim.keymap.set("n", "gz", "<cmd>Pick marks<cr>")
vim.keymap.set("n", "gq", "<cmd>Pick list scope='quickfix'<cr>")
vim.keymap.set("n", "gl", "<cmd>Pick list scope='location'<cr>")
vim.keymap.set("n", "gj", "<cmd>Pick list scope='jump'<cr>")
vim.keymap.set("n", "gc", "<cmd>Pick list scope='change'<cr>")
vim.keymap.set("n", "gb", "<cmd>Pick buffers<cr>")
vim.keymap.set("n", "gf", "<cmd>Pick files tool='git'<cr>")
vim.keymap.set("n", "g;", "<cmd>Pick resume<cr>")
vim.keymap.set("n", "g/", "<cmd>Pick grep_live<cr>")
vim.keymap.set("n", "gs", "<cmd>Pick lsp scope='document_symbol'<cr>")
vim.keymap.set("n", "gS", "<cmd>Pick lsp scope='workspace_symbol'<cr>")
vim.keymap.set("n", "ge", "<cmd>Pick diagnostic scope='current'<cr>")
vim.keymap.set("n", "gE", "<cmd>Pick diagnostic<cr>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", "<cmd>Pick lsp scope='definition'<cr>")
vim.keymap.set("n", "gi", "<cmd>Pick lsp scope='implementation'<cr>")
vim.keymap.set("n", "gI", "<cmd>Pick lsp scope='type_definition'<cr>")
vim.keymap.set("n", "gr", "<cmd>Pick lsp scope='references'<cr>")
vim.keymap.set("n", "cd", vim.lsp.buf.rename)
vim.keymap.set("n", "-", "<CMD>lua MiniFiles.open()<CR>")
vim.keymap.set({ "n", "v" }, "g.", vim.lsp.buf.code_action)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.api.nvim_create_autocmd("BufWritePre", { buffer = bufnr, callback = function() vim.lsp.buf.format() end })
