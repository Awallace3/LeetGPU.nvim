---@class lg.Lang
---@field id integer
---@field slug string
---@field name string

---@type lg.Lang[]
local langs = {
    { id = 1, slug = "cpp", name = "C++" },
    { id = 2, slug = "cuda", name = "CUDA C++" },
    { id = 3, slug = "python", name = "Python" },
    { id = 4, slug = "python3", name = "Python3" },
    { id = 5, slug = "c", name = "C" },
}

return langs
