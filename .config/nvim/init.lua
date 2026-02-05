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
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions:append("fuzzy")
vim.opt.wildignore:append({ "*/.git/*", "*/build/*" })
vim.opt.path:append("**")

vim.pack.add({
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/supermaven-inc/supermaven-nvim",
})

require("lazydev").setup()
require("supermaven-nvim").setup({})

for _, server in ipairs({ "lua_ls", "clangd", "gopls", "gdscript" }) do
    vim.lsp.enable(server)
end

vim.keymap.set({ "n", "v" }, "+y", [["+y]])
vim.keymap.set({ "n", "v" }, "+d", [["_d]])
vim.keymap.set("n", "-", "<cmd>Explore<cr>")
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>cm", ":make ")
vim.keymap.set("n", "<leader>cc", "<cmd>make<cr>")
vim.keymap.set("n", "<leader>ff", ":find ")

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
