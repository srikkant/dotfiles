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
deps.add({ source = "rose-pine/neovim" })
deps.add({ source = "neovim/nvim-lspconfig" })
deps.add({ source = "nvim-treesitter/nvim-treesitter" })
deps.add({ source = "andrewferrier/debugprint.nvim" })
deps.add({ source = "nvimtools/none-ls.nvim" })
deps.add({ source = "folke/trouble.nvim" })
deps.add({ source = "ibhagwan/fzf-lua" })
deps.add({ source = "stevearc/oil.nvim" })
deps.add({ source = "saghen/blink.cmp", checkout = "v0.7.6" })

require("rose-pine").setup({ styles = { italic = false, transparency = true } })
require("debugprint").setup()
require("trouble").setup()
require("mini.basics").setup({})
require("mini.icons").setup({})
require("mini.bracketed").setup({})
require("mini.diff").setup({})
require("mini.git").setup({})
require("fzf-lua").setup({})
require("oil").setup()

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

for _, lsp in ipairs({ "cssls", "eslint", "html", "custom_elements_ls", "ts_ls", "gopls", "templ" }) do
    require("lspconfig")[lsp].setup({ capabilities = capabilities })
end

require("blink.cmp").setup()

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.sql_formatter,
    },
})

vim.cmd([[colorscheme rose-pine]])

vim.keymap.set("n", "gb", "<cmd>FzfLua buffers<cr>")
vim.keymap.set("n", "gf", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "g;", "<cmd>FzfLua resume<cr>")
vim.keymap.set("n", "g/", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "gs", "<cmd>FzfLua lsp_document_symbols<cr>")
vim.keymap.set("n", "ge", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>")
vim.keymap.set("n", "gE", "<cmd>Trouble diagnostics toggle focus=true<cr>")
vim.keymap.set("n", "gc", "<cmd>Trouble lsp toggle focus=true<cr>")
vim.keymap.set("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>")
vim.keymap.set("n", "gD", "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>")
vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>")
vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>")
vim.keymap.set("n", "cd", vim.lsp.buf.rename)
vim.keymap.set("n", "'", "<CMD>Oil<CR>")
vim.keymap.set({ "n", "v" }, "g.", vim.lsp.buf.code_action)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.api.nvim_create_autocmd("BufWritePre", { buffer = bufnr, callback = function() vim.lsp.buf.format() end })
