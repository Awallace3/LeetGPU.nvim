local NuiPopup = require("nui.popup")
local config = require("leetgpu.config")

---@class lg.cli.OutputPopup
---@field popup NuiPopup
---@field bufnr number
local OutputPopup = {}
OutputPopup.__index = OutputPopup

---Create new output popup
---@param opts? table Options: title, width, height, position
---@return lg.cli.OutputPopup
function OutputPopup:new(opts)
    opts = opts or {}
    
    local obj = setmetatable({}, OutputPopup)
    
    obj.popup = NuiPopup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = opts.title or " LeetGPU CLI Output ",
                top_align = "center",
            },
        },
        position = opts.position or "50%",
        size = {
            width = opts.width or "90%",
            height = opts.height or "75%",
        },
        buf_options = {
            modifiable = false,
            readonly = true,
        },
    })
    
    return obj
end

---Mount the popup
function OutputPopup:mount()
    self.popup:mount()
    self.bufnr = self.popup.bufnr
    self:setup_keymaps()
end

---Setup keymaps for the popup
function OutputPopup:setup_keymaps()
    local toggle_keys = config.user.keys.toggle or { "q" }
    
    -- Close popup on toggle keys
    for _, key in ipairs(toggle_keys) do
        self.popup:map("n", key, function()
            self:unmount()
        end, { noremap = true })
    end
    
    -- Allow scrolling
    self.popup:map("n", "j", "j", { noremap = true })
    self.popup:map("n", "k", "k", { noremap = true })
    self.popup:map("n", "<Down>", "j", { noremap = true })
    self.popup:map("n", "<Up>", "k", { noremap = true })
    self.popup:map("n", "gg", "gg", { noremap = true })
    self.popup:map("n", "G", "G", { noremap = true })
    self.popup:map("n", "<C-d>", "<C-d>", { noremap = true })
    self.popup:map("n", "<C-u>", "<C-u>", { noremap = true })
end

---Set content in the popup
---@param lines string|string[] Content lines
function OutputPopup:set_content(lines)
    if type(lines) == "string" then
        lines = vim.split(lines, "\n")
    end
    
    vim.api.nvim_buf_set_option(self.bufnr, "modifiable", true)
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(self.bufnr, "modifiable", false)
end

---Append content to the popup
---@param lines string|string[] Content lines to append
function OutputPopup:append_content(lines)
    if type(lines) == "string" then
        lines = vim.split(lines, "\n")
    end
    
    local current_lines = vim.api.nvim_buf_line_count(self.bufnr)
    
    vim.api.nvim_buf_set_option(self.bufnr, "modifiable", true)
    vim.api.nvim_buf_set_lines(self.bufnr, current_lines, -1, false, lines)
    vim.api.nvim_buf_set_option(self.bufnr, "modifiable", false)
end

---Clear content in the popup
function OutputPopup:clear()
    vim.api.nvim_buf_set_option(self.bufnr, "modifiable", true)
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, {})
    vim.api.nvim_buf_set_option(self.bufnr, "modifiable", false)
end

---Update popup title
---@param title string New title
function OutputPopup:set_title(title)
    self.popup.border:set_text("top", " " .. title .. " ", "center")
end

---Unmount the popup
function OutputPopup:unmount()
    if self.popup then
        self.popup:unmount()
    end
end

---Check if popup is mounted
---@return boolean
function OutputPopup:is_mounted()
    return self.popup and self.popup.winid and vim.api.nvim_win_is_valid(self.popup.winid)
end

return OutputPopup
