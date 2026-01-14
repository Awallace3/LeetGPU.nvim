---@class lg.ui.Utils
local utils = {}

---Center text in a line
---@param text string
---@param width number
---@return string
function utils.center(text, width)
    local padding = math.floor((width - #text) / 2)
    return string.rep(" ", padding) .. text
end

---Pad text to a specific width
---@param text string
---@param width number
---@param align? "left"|"center"|"right"
---@return string
function utils.pad(text, width, align)
    align = align or "left"
    local len = #text
    
    if len >= width then
        return text
    end
    
    local padding = width - len
    
    if align == "center" then
        local left = math.floor(padding / 2)
        local right = padding - left
        return string.rep(" ", left) .. text .. string.rep(" ", right)
    elseif align == "right" then
        return string.rep(" ", padding) .. text
    else
        return text .. string.rep(" ", padding)
    end
end

return utils
