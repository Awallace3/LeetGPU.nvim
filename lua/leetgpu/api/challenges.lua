local urls = require("leetgpu.api.urls")
local utils = require("leetgpu.api.utils")

---@class lg.api.Challenges
local challenges = {}

---Get list of all challenges
---@return table|nil, string|nil
function challenges.list()
    local url = urls.base .. urls.challenges
    return utils.request("GET", url, utils.get_auth_headers())
end

---Get a specific challenge by ID
---@param id string
---@return table|nil, string|nil
function challenges.get(id)
    local url = urls.base .. string.format(urls.challenge, id)
    return utils.request("GET", url, utils.get_auth_headers())
end

---Submit solution for a challenge
---@param id string
---@param code string
---@param lang string
---@return table|nil, string|nil
function challenges.submit(id, code, lang)
    local url = urls.base .. string.format(urls.submit, id)
    local body = vim.json.encode({
        code = code,
        language = lang,
    })
    return utils.request("POST", url, utils.get_auth_headers(), body)
end

return challenges
