-- Just copied this verbatim from -
-- https://github.com/bew/dotfiles/blob/main/gui/wezterm/lib/mystdlib.lua

local stdlib = {} -- my "table" stdlib

-- For associative arrays
function stdlib.merge(t1, t2)
    for key, value in pairs(t2) do
        t1[key] = value
    end

    return t1
end

return {
    stdlib = stdlib,
}
