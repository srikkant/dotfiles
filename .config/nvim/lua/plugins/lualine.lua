return {
    "nvim-lualine/lualine.nvim",
    after = "nvimdev/lspsaga.nvim",
    config = function()
        local custom_theme = require("lualine.themes.no-clown-fiesta")
        custom_theme.normal.a.bg = "#00000000"
        custom_theme.normal.b.bg = "#00000000"
        custom_theme.normal.c.bg = "#00000000"
        custom_theme.insert.a.bg = "#00000000"
        custom_theme.visual.a.bg = "#00000000"
        custom_theme.command.a.bg = "#00000000"
        custom_theme.replace.a.bg = "#00000000"
        custom_theme.inactive.a.bg = "#00000000"
        custom_theme.inactive.b.bg = "#00000000"
        custom_theme.inactive.c.bg = "#00000000"

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
