local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })

null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.eslint_d,

        null_ls.builtins.diagnostics.editorconfig_checker,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.fish,

        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylelint,
        null_ls.builtins.formatting.stylua,
 
        null_ls.builtins.formatting.rustfmt
    },

    on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup_format,
                buffer = 0,
                callback = function() vim.lsp.buf.formatting_seq_sync() end
            })
        end
    end,
})
