---@class lg.Theme
local theme = {}

---@type lg.highlights
local default_theme = {
    ["normal"] = { fg = "#FFFFFF" },
    ["alt"] = { fg = "#D0D0D0" },
    ["LgEasy"] = { fg = "#00FF00" },
    ["LgMedium"] = { fg = "#FFA500" },
    ["LgHard"] = { fg = "#FF0000" },
    ["LgTitle"] = { fg = "#00FFFF", bold = true },
    ["LgHeader"] = { fg = "#FFFF00", bold = true },
}

---Setup theme
function theme.setup()
    local config = require("leetgpu.config")
    local user_theme = config.user.theme or {}
    
    local final_theme = vim.tbl_deep_extend("force", default_theme, user_theme)
    
    for group, attrs in pairs(final_theme) do
        vim.api.nvim_set_hl(0, group, attrs)
    end
end

return theme
