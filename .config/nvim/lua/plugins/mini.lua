local minifiles_toggle = function(...)
    local MiniFiles = require("mini.files")
    if not MiniFiles.close() then
        MiniFiles.open(...)
    end
end

local get_diagnostics = function()
    local t = {}
    local levels = { "Error", "Warn", "Info", "Hint" }
    local counts = {}
    local severity = vim.diagnostic.severity

    for _, d in ipairs(vim.diagnostic.get(0)) do
        counts[d.severity] = (counts[d.severity] or 0) + 1
    end

    for _, level in ipairs(levels) do
        local n = counts[severity[string.upper(level)]] or 0
        if n > 0 then
            table.insert(t, { hl = "StatuslineDiagnostic" .. level, strings = { string.format("• %s", n) } })
        end
    end

    return t
end

return {
    {
        "echasnovski/mini.nvim",
        lazy = false,
        version = "*",
        config = function()
            local basics = require("mini.basics")
            local comment = require("mini.comment")
            local extra = require("mini.extra")
            local files = require("mini.files")
            local indentscope = require("mini.indentscope")
            local pairs = require("mini.pairs")
            local pick = require("mini.pick")
            local statusline = require("mini.statusline")
            local surround = require("mini.surround")

            basics.setup({})
            comment.setup({})
            extra.setup({})
            pairs.setup({})
            surround.setup({})
            pick.setup({ source = { show = pick.default_show } })
            indentscope.setup({ draw = { animation = indentscope.gen_animation.none() } })

            files.setup({
                content = { prefix = function() end },
                windows = { max_number = 3, width_focus = 50, width_nofocus = 40, width_preview = 80, preview = true },
            })

            statusline.setup({
                use_icons = false,
                content = {
                    active = function()
                        local groups = {}
                        local mode = statusline.section_mode({ trunc_width = 120 })
                        local filename = statusline.section_filename({ trunc_width = 140 })
                        local diagnostics = get_diagnostics()

                        table.insert(groups, { strings = { mode }, hl = "StatuslineMode" })
                        for _, d in ipairs(diagnostics) do
                            table.insert(groups, d)
                        end

                        -- Add file name & position
                        table.insert(groups, { strings = { filename }, hl = "StatuslineFile" })
                        table.insert(groups, "%=")
                        table.insert(groups, { strings = { "%2v:%l" } })

                        return statusline.combine_groups(groups)
                    end,
                    inactive = function()
                        local filename = statusline.section_filename({ trunc_width = 140 })
                        return statusline.combine_groups({
                            { hl = "StatuslineFile", strings = { filename } },
                        })
                    end,
                },
            })
        end,
        keys = {
            {
                "'",
                function()
                    minifiles_toggle(vim.api.nvim_buf_get_name(0), true)
                end,
            },
            {
                "<leader>'",
                function()
                    minifiles_toggle(vim.loop.cwd(), true)
                end,
            },
            {
                "<leader>b",
                function()
                    require("mini.pick").builtin.buffers()
                end,
            },
            {
                "<leader>f",
                function()
                    require("mini.pick").builtin.files()
                end,
            },
            {
                "<leader>'",
                function()
                    require("mini.pick").builtin.resume()
                end,
            },
            {
                "<leader>S",
                function()
                    require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
                end,
            },
            {
                "<leader>s",
                function()
                    require("mini.extra").pickers.lsp({ scope = "document_symbol" })
                end,
            },
            {
                "<leader>/",
                function()
                    require("mini.pick").builtin.grep_live()
                end,
            },
        },
    },
}
