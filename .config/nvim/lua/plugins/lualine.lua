local colors = {
    bg = "#00000000",
    fg = "#D0D0D0",
}

local custom_theme = {
    normal = {
        a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
    },
    insert = { a = { fg = colors.fg, bg = colors.bg, gui = "bold" } },
    visual = { a = { fg = colors.fg, bg = colors.bg, gui = "bold" } },
    command = { a = { fg = colors.fg, bg = colors.bg, gui = "bold" } },
    replace = { a = { fg = colors.fg, bg = colors.bg, gui = "bold" } },
    inactive = {
        a = { fg = colors.fg, bg = colors.bg },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
    },
}

return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = false,
                theme = custom_theme,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "filename" },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = { error = "• ", warn = "• ", info = "• ", hint = "• " },
                    },
                },
                lualine_x = { "filetype" },
                lualine_y = { "location" },
                lualine_z = { "tabs" },
            },
        })
    end,
}
