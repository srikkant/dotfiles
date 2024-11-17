local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path })
    vim.cmd("packadd mini.nvim | helptags ALL")
end

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldenable = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.relativenumber = true

local deps = require("mini.deps")
deps.setup()

deps.add("nvim-lua/plenary.nvim")
deps.add("rose-pine/neovim")
deps.add("neovim/nvim-lspconfig")
deps.add("nvim-treesitter/nvim-treesitter")
deps.add("andrewferrier/debugprint.nvim")
deps.add("nvimtools/none-ls.nvim")
deps.add("folke/trouble.nvim")
deps.add("github/copilot.vim")

require("rose-pine").setup({ styles = { italic = false, transparency = true } })
require("debugprint").setup()
require("trouble").setup()
require("mini.basics").setup({})
require("mini.icons").setup({})
require("mini.bracketed").setup({})
require("mini.completion").setup({})
require("mini.diff").setup({})
require("mini.git").setup({})
require("mini.files").setup({})
require("mini.pick").setup({})

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

for _, lsp in ipairs({ "cssls", "eslint", "html", "ts_ls", "gopls", "templ" }) do
    require("lspconfig")[lsp].setup({})
end

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

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]])
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]])
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]])
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]])
vim.keymap.set("n", "gb", "<cmd>Pick buffers<cr>")
vim.keymap.set("n", "gf", "<cmd>Pick files<cr>")
vim.keymap.set("n", "g;", "<cmd>Pick resume<cr>")
vim.keymap.set("n", "g/", "<cmd>Pick grep_live<cr>")
vim.keymap.set("n", "ge", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>")
vim.keymap.set("n", "gE", "<cmd>Trouble diagnostics toggle focus=true<cr>")
vim.keymap.set("n", "gc", "<cmd>Trouble lsp toggle focus=true<cr>")
vim.keymap.set("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>")
vim.keymap.set("n", "gD", "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>")
vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>")
vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>")
vim.keymap.set("n", "gs", "<cmd>Trouble symbols toggle focus=true<cr>")
vim.keymap.set("n", "cd", vim.lsp.buf.rename)
vim.keymap.set("n", "'", function() require("mini.files").open((vim.api.nvim_buf_get_name(0)), true) end)
vim.keymap.set({ "n", "v" }, "g.", vim.lsp.buf.code_action)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.api.nvim_create_autocmd("BufWritePre", { buffer = bufnr, callback = function() vim.lsp.buf.format() end })
