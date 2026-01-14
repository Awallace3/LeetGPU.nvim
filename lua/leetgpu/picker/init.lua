---@class lg.Picker
local picker = {}

---Show challenge picker
---@param challenges table[]
---@param callback fun(challenge: table)
function picker.show(challenges, callback)
    local log = require("leetgpu.logger")
    
    -- TODO: Implement picker integration
    -- This should work with telescope, fzf-lua, or snacks-picker
    
    log.warn("Picker not yet implemented. Please install a picker plugin (telescope, fzf-lua, or snacks-picker)")
end

---Get available picker provider
---@return string|nil
function picker.get_provider()
    local config = require("leetgpu.config")
    
    if config.user.picker and config.user.picker.provider then
        return config.user.picker.provider
    end
    
    -- Auto-detect available picker
    local providers = { "snacks-picker", "fzf-lua", "telescope", "mini-picker" }
    for _, provider in ipairs(providers) do
        local ok = pcall(require, provider)
        if ok then
            return provider
        end
    end
    
    return nil
end

return picker
