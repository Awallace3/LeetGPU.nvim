local config = require("leetgpu.config")
local P = require("plenary.path")

---@class lg.Cache
local cache = {}

---Get cache file path
---@param name string
---@return Path
function cache.get_path(name)
    return config.storage.cache / (name .. ".json")
end

---Read from cache
---@param name string
---@return table|nil
function cache.read(name)
    local path = cache.get_path(name)
    if not path:exists() then
        return nil
    end
    
    local content = path:read()
    if not content then
        return nil
    end
    
    local ok, data = pcall(vim.json.decode, content)
    if not ok then
        local log = require("leetgpu.logger")
        log.warn("Failed to decode cache: " .. name)
        return nil
    end
    
    return data
end

---Write to cache
---@param name string
---@param data table
---@return boolean
function cache.write(name, data)
    local path = cache.get_path(name)
    local ok, content = pcall(vim.json.encode, data)
    if not ok then
        local log = require("leetgpu.logger")
        log.error("Failed to encode cache: " .. name)
        return false
    end
    
    path:write(content, "w")
    return true
end

---Clear cache
---@param name? string If nil, clear all cache
function cache.clear(name)
    if name then
        local path = cache.get_path(name)
        if path:exists() then
            path:rm()
        end
    else
        -- Clear all cache files
        for _, file in ipairs(config.storage.cache:glob("*.json")) do
            P:new(file):rm()
        end
    end
end

return cache
