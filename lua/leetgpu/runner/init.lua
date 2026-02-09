local log = require("leetgpu.logger")
local cli = require("leetgpu.cli")
local file_manager = require("leetgpu.cli.file_manager")
local OutputPopup = require("leetgpu.cli.output_popup")
local config = require("leetgpu.config")

---@class lg.Runner
local runner = {}

---Run the current buffer with LeetGPU CLI
---@param opts? table Options: mode, gpu, problem_name
function runner.run_current_buffer(opts)
    opts = opts or {}
    
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" or not vim.fn.filereadable(current_file) then
        log.error("No file to run. Please save the buffer first.")
        vim.notify("No file to run. Please save the buffer first.", vim.log.levels.ERROR)
        return
    end
    
    -- Check if it's a .cu file
    if not current_file:match("%.cu$") then
        log.warn("Current file is not a .cu file. LeetGPU CLI expects CUDA files.")
        vim.notify("Warning: Current file is not a .cu file", vim.log.levels.WARN)
    end
    
    -- Get mode and GPU from config or opts
    local mode = opts.mode or config.user.cli.mode or "functional"
    local gpu = opts.gpu or config.user.cli.gpu
    
    -- Create output popup
    local popup = OutputPopup:new({ title = "LeetGPU - Running..." })
    popup:mount()
    popup:set_content({ "Running leetgpu CLI...", "", "File: " .. current_file, "Mode: " .. mode })
    if gpu then
        popup:append_content({ "GPU: " .. gpu })
    end
    popup:append_content({ "", "Please wait..." })
    
    -- Run the CLI
    cli.run(current_file, { mode = mode, gpu = gpu }, function(success, output, error)
        if success then
            popup:set_title("LeetGPU - Success")
            popup:set_content({ "✓ Execution completed successfully!", "", "Output:", "" })
            if output and output ~= "" then
                popup:append_content(vim.split(output, "\n"))
            end
        else
            popup:set_title("LeetGPU - Error")
            popup:set_content({ "✗ Execution failed!", "", "Error:", "" })
            if error and error ~= "" then
                popup:append_content(vim.split(error, "\n"))
            end
            if output and output ~= "" then
                popup:append_content({ "", "Output:", "" })
                popup:append_content(vim.split(output, "\n"))
            end
        end
    end)
end

---Run a specific problem
---@param problem_name string
---@param opts? table Options: mode, gpu
function runner.run_problem(problem_name, opts)
    opts = opts or {}
    
    local problem_dir = file_manager.get_problem_dir(problem_name)
    local cu_file = problem_dir / (problem_name .. ".cu")
    
    if not cu_file:exists() then
        log.error("Problem file does not exist: " .. cu_file:absolute())
        vim.notify("Problem file not found: " .. problem_name .. ".cu", vim.log.levels.ERROR)
        return
    end
    
    local mode = opts.mode or config.user.cli.mode or "functional"
    local gpu = opts.gpu or config.user.cli.gpu
    
    -- Create output popup
    local popup = OutputPopup:new({ title = "LeetGPU - Running " .. problem_name })
    popup:mount()
    popup:set_content({ "Running leetgpu CLI...", "", "Problem: " .. problem_name, "Mode: " .. mode })
    if gpu then
        popup:append_content({ "GPU: " .. gpu })
    end
    popup:append_content({ "", "Please wait..." })
    
    -- Run the CLI
    cli.run(cu_file:absolute(), { mode = mode, gpu = gpu }, function(success, output, error)
        if success then
            popup:set_title("LeetGPU - Success: " .. problem_name)
            popup:set_content({ "✓ Execution completed successfully!", "", "Output:", "" })
            if output and output ~= "" then
                popup:append_content(vim.split(output, "\n"))
            end
        else
            popup:set_title("LeetGPU - Error: " .. problem_name)
            popup:set_content({ "✗ Execution failed!", "", "Error:", "" })
            if error and error ~= "" then
                popup:append_content(vim.split(error, "\n"))
            end
            if output and output ~= "" then
                popup:append_content({ "", "Output:", "" })
                popup:append_content(vim.split(output, "\n"))
            end
        end
    end)
end

---Show CUDA version
---@param mode? string "functional" or "cycle-accurate"
function runner.show_cuda_version(mode)
    mode = mode or config.user.cli.mode or "functional"
    
    local popup = OutputPopup:new({ title = "LeetGPU - CUDA Version" })
    popup:mount()
    popup:set_content({ "Getting CUDA version...", "", "Mode: " .. mode, "", "Please wait..." })
    
    cli.cuda_version(mode, function(success, output, error)
        if success then
            popup:set_title("LeetGPU - CUDA Version (" .. mode .. ")")
            popup:set_content({ "CUDA Version Information:", "", output or "No output" })
        else
            popup:set_title("LeetGPU - Error")
            popup:set_content({ "Failed to get CUDA version", "", "Error:", error or "Unknown error" })
        end
    end)
end

---Show available GPUs
function runner.show_gpus()
    local popup = OutputPopup:new({ title = "LeetGPU - Available GPUs" })
    popup:mount()
    popup:set_content({ "Getting available GPUs...", "", "Please wait..." })
    
    cli.list_gpus(function(success, output, error)
        if success then
            popup:set_title("LeetGPU - Available GPUs")
            popup:set_content({ "Available GPU Options:", "", output or "No GPUs found" })
        else
            popup:set_title("LeetGPU - Error")
            popup:set_content({ "Failed to list GPUs", "", "Error:", error or "Unknown error" })
        end
    end)
end

---Run the current challenge (legacy compatibility)
---@param code string
---@param lang string
---@param test_cases? table
---@return table|nil, string|nil
function runner.run(code, lang, test_cases)
    log.info("Running code...")
    
    -- TODO: Implement actual code execution
    -- This would involve sending the code to LeetGPU API
    
    return nil, "Not implemented yet"
end

---Submit the current challenge (legacy compatibility)
---@param code string
---@param lang string
---@return table|nil, string|nil
function runner.submit(code, lang)
    log.info("Submitting code...")
    
    -- TODO: Implement actual code submission
    -- This would involve sending the code to LeetGPU API
    
    return nil, "Not implemented yet"
end

return runner
