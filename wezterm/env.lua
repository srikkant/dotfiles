---@diagnostic disable: need-check-nil
local open = io.open

-- Parse environment variables string.(based on: https://github.com/UrNightmaree/redotenv.lua/blob/main/redotenv.lua)  
---@param str string
---@return table
local function parse(str)
    local envMap = {}
    for l in str:gmatch "([^\n]+)" do
        local key, is_value
        for token in l:gmatch "([^=]+)" do
            token = string.gsub(token, '%s+', '')
            if not is_value then
                key = token
            else
                envMap[key] = token
            end
            is_value = true
        end
    end
    return envMap
end

-- loads and reads the env file.
---@return table
local function load()
    local file = open("./.env",'r')
    local values = {};
    if file then
        values = parse(file:read "*a")
        file:close()
    end
    return values
end

return {
    load = load,
}
