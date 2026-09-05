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
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/supermaven-inc/supermaven-nvim",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/thehamsta/nvim-dap-virtual-text"
})

require("fzf-lua").setup()
require("mason").setup()
require("supermaven-nvim").setup({})

require("conform").setup({
    formatters_by_ft = {
        markdown = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

for _, server in ipairs({ "lua_ls", "ols" }) do
    vim.lsp.enable(server)
end

local dap = require("dap")

dap.adapters.codelldb = {
    type = "executable",
    command = "codelldb",
}

dap.configurations.odin = {
    {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.getcwd() .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
    },
}

require("nvim-dap-virtual-text").setup()

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

vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F7>", dap.terminate)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)

vim.keymap.set("n", "<F6>", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_element(widgets.scopes)
end)

vim.keymap.set("n", "<F8>", function()
    require("dap.ui.widgets").hover()
end)

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

        vim.keymap.set("n", "gd", vim.lsp.buf.definition)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
    end,
})

vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    end
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
