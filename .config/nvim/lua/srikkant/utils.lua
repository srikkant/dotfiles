local M = {}

local toggle_mini_files = function(...)
    local files = require("mini.files")
    if not files.close() then files.open(...) end
end

M.toggle_files_explorer = function() toggle_mini_files(vim.api.nvim_buf_get_name(0), true) end
M.toggle_files_explorer_cwd = function() toggle_mini_files(vim.loop.cwd(), true) end

M.opts = function(desc)
    local opts = { noremap = true, silent = true }
    opts.desc = desc
    return opts
end

return M
