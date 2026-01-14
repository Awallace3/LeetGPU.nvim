local config = require("leetgpu.config")

---@class lg.Logger
local logger = {}

local levels = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
}

---Log a message
---@param level integer
---@param msg string
---@param ... any
local function log(level, msg, ...)
    if not config.user.logging then
        return
    end

    local level_names = {
        [levels.DEBUG] = "DEBUG",
        [levels.INFO] = "INFO",
        [levels.WARN] = "WARN",
        [levels.ERROR] = "ERROR",
    }

    local formatted_msg = string.format("[LeetGPU.nvim] [%s] %s", level_names[level], msg)
    
    if level == levels.ERROR then
        vim.notify(formatted_msg, vim.log.levels.ERROR)
    elseif level == levels.WARN then
        vim.notify(formatted_msg, vim.log.levels.WARN)
    elseif level == levels.INFO then
        vim.notify(formatted_msg, vim.log.levels.INFO)
    else
        vim.notify(formatted_msg, vim.log.levels.DEBUG)
    end
end

---Log debug message
---@param msg string
---@param ... any
function logger.debug(msg, ...)
    if config.debug then
        log(levels.DEBUG, msg, ...)
    end
end

---Log info message
---@param msg string
---@param ... any
function logger.info(msg, ...)
    log(levels.INFO, msg, ...)
end

---Log warning message
---@param msg string
---@param ... any
function logger.warn(msg, ...)
    log(levels.WARN, msg, ...)
end

---Log error message
---@param msg string
---@param ... any
function logger.error(msg, ...)
    log(levels.ERROR, msg, ...)
end

return logger
