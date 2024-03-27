return {
    {
        "kevinhwang91/nvim-ufo",
        lazy = false,
        dependencies = {
            "kevinhwang91/promise-async",
        },
        keys = {
            {
                "zK",
                function()
                    require("ufo").peekFoldedLinesUnderCursor()
                end,
            },
        },
    },
}
