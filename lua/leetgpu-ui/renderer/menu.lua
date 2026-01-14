local NuiPopup = require("nui.popup")
local NuiLayout = require("nui.layout")

---@class lg.ui.Menu
---@field popup NuiPopup
local Menu = {}
Menu.__index = Menu

function Menu:new()
    local obj = setmetatable({}, Menu)
    return obj
end

function Menu:mount()
    self.popup = NuiPopup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = " LeetGPU.nvim ",
                top_align = "center",
            },
        },
        position = "50%",
        size = {
            width = "80%",
            height = "60%",
        },
    })

    self.popup:mount()
    self:render()
    self:setup_keymaps()
end

function Menu:render()
    local lines = {
        "",
        "Welcome to LeetGPU.nvim!",
        "",
        "This plugin is modeled after leetcode.nvim but for LeetGPU.com",
        "",
        "Available commands:",
        "  :LeetGPUMenu  - Open this menu",
        "  :LeetGPUExit  - Exit LeetGPU",
        "",
        "Press 'q' to close this menu",
        "",
    }

    vim.api.nvim_buf_set_lines(self.popup.bufnr, 0, -1, false, lines)
    vim.bo[self.popup.bufnr].modifiable = false
end

function Menu:setup_keymaps()
    local config = require("leetgpu.config")
    local toggle_keys = config.user.keys.toggle or { "q" }
    
    for _, key in ipairs(toggle_keys) do
        self.popup:map("n", key, function()
            self.popup:unmount()
        end, { noremap = true })
    end
end

return Menu
