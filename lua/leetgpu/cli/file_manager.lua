local P = require("plenary.path")
local log = require("leetgpu.logger")

---@class lg.FileManager
local file_manager = {}

---Get the base directory for LeetGPU files
---@return Path
function file_manager.get_base_dir()
    local home = vim.fn.expand("~")
    return P:new(home, ".leetgpu")
end

---Get or create problem directory
---@param problem_name string Name of the problem
---@return Path
function file_manager.get_problem_dir(problem_name)
    local base_dir = file_manager.get_base_dir()
    local problem_dir = base_dir / problem_name
    
    if not problem_dir:exists() then
        problem_dir:mkdir({ parents = true })
        log.info("Created problem directory: " .. problem_dir:absolute())
    end
    
    return problem_dir
end

---Create or get CUDA file for problem
---@param problem_name string Name of the problem
---@param content? string Initial content for the file
---@return Path, boolean (path, created)
function file_manager.get_or_create_cuda_file(problem_name, content)
    local problem_dir = file_manager.get_problem_dir(problem_name)
    local file_path = problem_dir / (problem_name .. ".cu")
    
    local created = false
    if not file_path:exists() then
        if content then
            file_path:write(content, "w")
        else
            -- Default CUDA template
            local default_content = [[#include <cuda_runtime.h>
#include <stdio.h>

__global__ void kernel() {
    // TODO: Implement kernel
}

int main() {
    // TODO: Implement main
    return 0;
}
]]
            file_path:write(default_content, "w")
        end
        created = true
        log.info("Created CUDA file: " .. file_path:absolute())
    end
    
    return file_path, created
end

---List all problem directories
---@return string[] List of problem names
function file_manager.list_problems()
    local base_dir = file_manager.get_base_dir()
    
    if not base_dir:exists() then
        return {}
    end
    
    local problems = {}
    for _, entry in ipairs(base_dir:readdir()) do
        local path = base_dir / entry
        if path:is_dir() then
            table.insert(problems, entry)
        end
    end
    
    return problems
end

---Delete problem directory
---@param problem_name string Name of the problem
---@return boolean success
function file_manager.delete_problem(problem_name)
    local problem_dir = file_manager.get_problem_dir(problem_name)
    
    if problem_dir:exists() then
        problem_dir:rm({ recursive = true })
        log.info("Deleted problem directory: " .. problem_dir:absolute())
        return true
    end
    
    return false
end

---Check if problem exists
---@param problem_name string Name of the problem
---@return boolean
function file_manager.problem_exists(problem_name)
    local problem_dir = file_manager.get_problem_dir(problem_name)
    return problem_dir:exists()
end

---Get all files in a problem directory
---@param problem_name string Name of the problem
---@return string[] List of file names
function file_manager.list_problem_files(problem_name)
    local problem_dir = file_manager.get_problem_dir(problem_name)
    
    if not problem_dir:exists() then
        return {}
    end
    
    local files = {}
    for _, entry in ipairs(problem_dir:readdir()) do
        local path = problem_dir / entry
        if path:is_file() then
            table.insert(files, entry)
        end
    end
    
    return files
end

return file_manager
