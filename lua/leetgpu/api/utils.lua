---@class lg.api.Utils
local utils = {}

---Make HTTP request
---@param method string
---@param url string
---@param headers? table
---@param body? string
---@return table|nil, string|nil
function utils.request(method, url, headers, body)
    -- Placeholder for HTTP request implementation
    -- This would use curl or Neovim's built-in HTTP client
    local log = require("leetgpu.logger")
    log.debug(string.format("API request: %s %s", method, url))
    
    -- TODO: Implement actual HTTP request
    return nil, "Not implemented yet"
end

---Get authentication headers
---@return table
function utils.get_auth_headers()
    local config = require("leetgpu.config")
    local headers = {
        ["Content-Type"] = "application/json",
    }
    
    -- Add session cookies if available
    if config.auth and config.auth.session then
        headers["Cookie"] = string.format("session=%s", config.auth.session)
    end
    
    return headers
end

return utils
