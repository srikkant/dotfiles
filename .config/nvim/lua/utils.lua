local M = {}

local toggle_mini_files = function(...)
    local files = require("mini.files")
    if not files.close() then
        files.open(...)
    end
end

M.get_diagnostics = function()
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

M.toggle_files_explorer = function()
    toggle_mini_files(vim.api.nvim_buf_get_name(0), true)
end

M.toggle_files_explorer_cwd = function()
    toggle_mini_files(vim.loop.cwd(), true)
end

return M
