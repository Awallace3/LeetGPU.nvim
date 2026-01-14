local config = require("leetgpu.config")

---@class lg.Command
local command = {}

---Setup commands
function command.setup()
    -- Register LeetGPU commands
    vim.api.nvim_create_user_command("LeetGPUMenu", function()
        require("leetgpu-ui.renderer.menu"):new():mount()
    end, { desc = "Open LeetGPU menu" })

    vim.api.nvim_create_user_command("LeetGPUExit", function()
        require("leetgpu").stop()
    end, { desc = "Exit LeetGPU" })
end

---Start LeetGPU with command
---@param opts table
function command.start_with_cmd(opts)
    local args = opts.fargs or {}
    local cmd = args[1] or "menu"

    if cmd == "menu" then
        local Menu = require("leetgpu-ui.renderer.menu")
        Menu:new():mount()
    elseif cmd == "exit" then
        require("leetgpu").stop()
    else
        local log = require("leetgpu.logger")
        log.warn("Unknown command: " .. cmd)
    end
end

return command
