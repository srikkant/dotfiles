local theme = {
    fill = "TabLineFill",
    -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
    head = "TabLine",
    current_tab = "TabLineSel",
    tab = "TabLine",
    win = "TabLine",
    tail = "TabLine",
}

local get_label = function(active, changed, visible)
    local label = active and { " " } or { " " }
    return label
end

return {
    {
        "akinsho/bufferline.nvim",
        enabled = false,
    },
    {
        "backdround/tabscope.nvim",
        lazy = false,
        config = function()
            require("tabscope").setup({})
        end,
    },
    {
        "nanozuki/tabby.nvim",
        lazy = false,
        config = function()
            require("tabby").setup({})

            require("tabby.tabline").set(function(line)
                local left_enclosure = {
                    { " ", hl = theme.head },
                    line.sep("", theme.head, theme.fill),
                }

                local buffers = require("utils.buffers").get()
                local buffer_nodes = {}

                for _, buffer in ipairs(buffers) do
                    local hl = buffer.is_current() and theme.current_tab or theme.tab
                    local buffer_node = {
                        line.sep("", hl, theme.fill),
                        get_label(buffer.is_current(), buffer.is_modified(), buffer.is_visible()),
                        buffer.name(),
                        line.sep("", hl, theme.fill),
                        hl = hl,
                        margin = " ",
                    }
                    table.insert(buffer_nodes, buffer_node)
                end

                local tabs = line.tabs().foreach(function(tab)
                    local hl = tab.is_current() and theme.current_tab or theme.tab
                    return {
                        line.sep("", hl, theme.fill),
                        get_label(tab.is_current(), false, true),
                        tab.name():gsub("%[%d+.*$", ""),
                        line.sep("", hl, theme.fill),
                        hl = hl,
                        margin = " ",
                    }
                end)

                local right_enclosure = {
                    line.sep("", theme.head, theme.fill),
                    { " ", hl = theme.fill },
                }

                return {
                    left_enclosure,
                    buffer_nodes,
                    line.spacer(),
                    tabs,
                    right_enclosure,
                    hl = background_color,
                }
            end)
        end,
    },
}
