---@class lg.Parser
local parser = {}

---Parse HTML description to plain text
---@param html string
---@return string
function parser.html_to_text(html)
    if not html then
        return ""
    end
    
    -- Simple HTML to text conversion
    -- Remove HTML tags
    local text = html:gsub("<[^>]+>", "")
    
    -- Decode HTML entities
    text = text:gsub("&lt;", "<")
    text = text:gsub("&gt;", ">")
    text = text:gsub("&amp;", "&")
    text = text:gsub("&quot;", '"')
    text = text:gsub("&#39;", "'")
    text = text:gsub("&nbsp;", " ")
    
    return text
end

---Parse challenge data
---@param data table
---@return lg.ui.Challenge
function parser.parse_challenge(data)
    return {
        id = data.id or "",
        title = data.title or "",
        difficulty = data.difficulty or "medium",
        description = parser.html_to_text(data.description or ""),
        slug = data.slug or "",
    }
end

return parser
