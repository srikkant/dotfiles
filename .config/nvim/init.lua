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
vim.opt.wildoptions:append("fuzzy")
vim.opt.wildignore:append({ "*/.git/*", "*/build/*" })
vim.opt.path:append("**")

vim.g.loaded_netrwPlugin = 1

vim.pack.add({
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/supermaven-inc/supermaven-nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/mikavilpas/yazi.nvim"
})

require("lazydev").setup()
require("fzf-lua").setup()
require("supermaven-nvim").setup({})
require("yazi").setup({})

for _, server in ipairs({ "lua_ls", "clangd", "gopls", "ols" }) do
    vim.lsp.enable(server)
end

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])
vim.keymap.set("n", "-", require("yazi").yazi)
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>cm", ":make ")
vim.keymap.set("n", "<leader>cc", "<cmd>make<cr>")
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
                    if vim.bo[args.buf].filetype == "go" then
                        vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
                    end
                    vim.lsp.buf.format({ id = client.id })
                end,
            })
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
