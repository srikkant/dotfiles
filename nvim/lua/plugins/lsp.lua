return {
    {
        "akinsho/flutter-tools.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim", -- optional for vim.ui.select
        },
    },
    {
        {
            "neovim/nvim-lspconfig",
            init = function()
                local keys = require("lazyvim.plugins.lsp.keymaps").get()
                -- disable keymaps
                keys[#keys + 1] = { "gr", false }
                keys[#keys + 1] = { "gd", false }
                keys[#keys + 1] = { "gp", false }
                keys[#keys + 1] = { "gt", false }
                keys[#keys + 1] = { "cd", false }
                keys[#keys + 1] = { "]e", false }
                keys[#keys + 1] = { "[e", false }
                keys[#keys + 1] = { "]E", false }
                keys[#keys + 1] = { "[E", false }
                -- disabled keymaps
            end,
            ---@class PluginLspOpts
            opts = {
                ---@type lspconfig.options
                opts = {
                    format = { timeout_ms = 1000 },
                },
                servers = {
                    svelte = {},
                    denols = {},
                },
                setup = {
                    tailwindcss = function()
                        return true
                    end,
                },
            },
        },
        {
            "jose-elias-alvarez/null-ls.nvim",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = { "mason.nvim" },
            opts = function()
                local null_ls = require("null-ls")
                local ts_condition = function(utils)
                    return utils.root_has_file({ "package.json" })
                end

                return {
                    root_dir = require("null-ls.utils").root_pattern(".git", "package.json"),
                    sources = {
                        debug = true,
                        sources = {
                            null_ls.builtins.formatting.eslint_d.with({
                                condition = ts_condition,
                            }),

                            null_ls.builtins.formatting.deno_fmt,

                            null_ls.builtins.formatting.prettierd.with({
                                extra_filetypes = { "svelte" },
                                condition = ts_condition,
                            }),

                            null_ls.builtins.formatting.stylelint,

                            null_ls.builtins.diagnostics.eslint_d.with({
                                condition = ts_condition,
                            }),

                            null_ls.builtins.code_actions.eslint_d.with({
                                condition = ts_condition,
                            }),

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
        {
            "glepnir/lspsaga.nvim",
            event = "LspAttach",
            config = function()
                require("lspsaga").setup({})
            end,
            dependencies = { { "nvim-tree/nvim-web-devicons" } },
            keys = {
                { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Action", mode = { "n", "v" } },
                { "gh", "<cmd>Lspsaga lsp_finder<CR>", desc = "Find References" },
                { "gr", "<cmd>Lspsaga rename<CR>", desc = "Rename" },
                { "gr", "<cmd>Lspsaga rename ++project<CR>", desc = "Rename" },
                { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
                { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "Goto Definition" },
                { "gt", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Peek Type definition" },
                { "gt", "<cmd>Lspsaga goto_type_definition<CR>", desc = "Goto Type definition" },
                { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Line Diagnostics" },
                { "<leader>cb", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "Buffer Diagnostics" },
                { "<leader>cw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", desc = "Workspace Diagnostics" },
                { "<leader>cc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Cursor Diagnostics" },
                { "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Prev Diagnostic" },
                { "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
                {
                    "[E",
                    function()
                        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
                    end,
                    desc = "Previous Error",
                },
                {
                    "]E",
                    function()
                        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
                    end,
                    desc = "Next Error",
                },
                { "<leader>o", "<cmd>Lspsaga outline<CR>", desc = "Toggle Outline" },
                { "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "Incoming calls" },
                { "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", desc = "Outgoing calls" },
            },
        },
    },
}
