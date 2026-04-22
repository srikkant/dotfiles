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

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/supermaven-inc/supermaven-nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/ibhagwan/fzf-lua",
})

require("fzf-lua").setup()
require("supermaven-nvim").setup({})
require("conform").setup({
    formatters_by_ft = {
        markdown = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})

for _, server in ipairs({ "lua_ls", "ols", "ts_ls", "marksman" }) do
    vim.lsp.enable(server)
end

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])
vim.keymap.set("n", "-", ":Ex<cr>")
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>cm", ":make ")
vim.keymap.set("n", "<leader>cc", "<cmd>make<cr>")
vim.keymap.set("n", "<leader>cr", "<cmd>make run<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua global<cr>")

vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end)
vim.keymap.set("n", "<leader>dn", function() require("dap").step_over() end)
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end)
vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end)
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end)
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.toggle() end)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        if client:supports_method("textDocument/completion", args.buf) then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
    end,
})

vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function() vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) end
})

vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank() end })
