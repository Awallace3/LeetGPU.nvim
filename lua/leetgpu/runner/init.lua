---@class lg.Runner
local runner = {}

---Run the current challenge
---@param code string
---@param lang string
---@param test_cases? table
---@return table|nil, string|nil
function runner.run(code, lang, test_cases)
    local log = require("leetgpu.logger")
    log.info("Running code...")
    
    -- TODO: Implement actual code execution
    -- This would involve sending the code to LeetGPU API
    
    return nil, "Not implemented yet"
end

---Submit the current challenge
---@param code string
---@param lang string
---@return table|nil, string|nil
function runner.submit(code, lang)
    local log = require("leetgpu.logger")
    log.info("Submitting code...")
    
    -- TODO: Implement actual code submission
    -- This would involve sending the code to LeetGPU API
    
    return nil, "Not implemented yet"
end

return runner
