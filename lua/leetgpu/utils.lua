local config = require("leetgpu.config")

local utils = {}

---Get language info by slug
---@param slug string
---@return lg.Lang|nil
function utils.get_lang(slug)
    for _, lang in ipairs(config.langs) do
        if lang.slug == slug then
            return lang
        end
    end
    return nil
end

---Execute hooks for a given event
---@param event string
---@param ... any
function utils.exec_hooks(event, ...)
    local hooks = config.user.hooks[event] or {}
    for _, hook in ipairs(hooks) do
        hook(...)
    end
end

---Convert table to string
---@param t table
---@return string
function utils.table_to_string(t)
    return vim.inspect(t)
end

---Check if table is empty
---@param t table
---@return boolean
function utils.is_empty(t)
    return next(t) == nil
end

return utils
