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
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true

local deps = require("mini.deps")
deps.setup()

local add = deps.add

add("nvim-lua/plenary.nvim")
add("folke/lazydev.nvim")
add("rose-pine/neovim")
add("neovim/nvim-lspconfig")
add("nvim-treesitter/nvim-treesitter")
add("andrewferrier/debugprint.nvim")
add("nvimtools/none-ls.nvim")
add("folke/trouble.nvim")
add("github/copilot.vim")

require("lazydev").setup()
require("rose-pine").setup({ styles = { italic = false, transparency = true } })
vim.cmd([[colorscheme rose-pine]])

require("debugprint").setup()
require("trouble").setup()

require("mini.basics").setup({})
require("mini.bracketed").setup({})
require("mini.comment").setup({})
require("mini.completion").setup({})
require("mini.diff").setup({})
require("mini.files").setup({})
require("mini.git").setup({})
require("mini.icons").setup({})
require("mini.pick").setup({})
require("mini.surround").setup({})

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
-- LSPs
--
for _, lsp in ipairs({ "cssls", "eslint", "html", "ts_ls", "gopls", "lua_ls" }) do
    require("lspconfig")[lsp].setup({})
end

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.goimports,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd(
                "BufWritePre",
                { buffer = bufnr, callback = function() vim.lsp.buf.format() end }
            )
        end
    end,
})

---
--- Keymaps
---
local key = vim.keymap.set

key("n", "=", [[<cmd>vertical resize +5<cr>]])
key("n", "-", [[<cmd>vertical resize -5<cr>]])
key("n", "+", [[<cmd>horizontal resize +2<cr>]])
key("n", "_", [[<cmd>horizontal resize -2<cr>]])
key("n", "gb", "<cmd>Pick buffers<cr>")
key("n", "gf", "<cmd>Pick files<cr>")
key("n", "g;", "<cmd>Pick resume<cr>")
key("n", "g/", "<cmd>Pick grep_live<cr>")
key("n", "ge", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>")
key("n", "gE", "<cmd>Trouble diagnostics toggle focus=true<cr>")
key("n", "gc", "<cmd>Trouble lsp toggle focus=true<cr>")
key("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true<cr>")
key("n", "gD", "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>")
key("n", "gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>")
key("n", "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>")
key("n", "gs", "<cmd>Trouble symbols toggle focus=true<cr>")
key("n", "cd", vim.lsp.buf.rename)
key("n", "'", function() require("mini.files").open((vim.api.nvim_buf_get_name(0)), true) end)
key({ "n", "v" }, "g.", vim.lsp.buf.code_action)
key({ "n", "v" }, "<leader>y", [["+y]])
key({ "n", "v" }, "<leader>d", [["_d]])
