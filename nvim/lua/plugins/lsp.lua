return {
    {
        {
            "jose-elias-alvarez/null-ls.nvim",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = { "mason.nvim" },
            opts = function()
                local null_ls = require("null-ls")
                return {
                    sources = {
                        debug = true,
                        sources = {
                            null_ls.builtins.formatting.eslint_d,
                            null_ls.builtins.formatting.prettierd.with({
                                extra_filetypes = { "svelte" },
                            }),
                            null_ls.builtins.formatting.stylelint,

                            null_ls.builtins.diagnostics.eslint_d,
                            null_ls.builtins.code_actions.eslint_d,

                            -- Lua
                            null_ls.builtins.formatting.stylua,

                            -- Rust
                            null_ls.builtins.formatting.rustfmt,

                            -- Golang
                            null_ls.builtins.formatting.goimports,
                            null_ls.builtins.formatting.golines,

                            -- Shell script
                            null_ls.builtins.code_actions.shellcheck,
                            null_ls.builtins.diagnostics.shellcheck,
                            null_ls.builtins.formatting.shellharden,
                            null_ls.builtins.formatting.shfmt,

                            -- YAML
                            null_ls.builtins.diagnostics.yamllint,
                        },
                    },
                }
            end,
        },
    }
}
