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

    -- CLI-related commands
    vim.api.nvim_create_user_command("LeetGPURun", function(opts)
        local runner = require("leetgpu.runner")
        local args = opts.fargs or {}
        
        -- Parse options
        local run_opts = {}
        for i = 1, #args, 2 do
            local key = args[i]
            local value = args[i + 1]
            if key == "--mode" or key == "-m" then
                run_opts.mode = value
            elseif key == "--gpu" or key == "-g" then
                run_opts.gpu = value
            end
        end
        
        runner.run_current_buffer(run_opts)
    end, { 
        desc = "Run current buffer with LeetGPU CLI",
        nargs = "*"
    })

    vim.api.nvim_create_user_command("LeetGPUCudaVersion", function(opts)
        local runner = require("leetgpu.runner")
        local args = opts.fargs or {}
        local mode = args[1] or "functional"
        runner.show_cuda_version(mode)
    end, { 
        desc = "Show CUDA version for specified mode",
        nargs = "?"
    })

    vim.api.nvim_create_user_command("LeetGPUListGpus", function()
        local runner = require("leetgpu.runner")
        runner.show_gpus()
    end, { desc = "List available GPU options" })

    vim.api.nvim_create_user_command("LeetGPUNewProblem", function(opts)
        local file_manager = require("leetgpu.cli.file_manager")
        local problem_name = opts.args
        
        if not problem_name or problem_name == "" then
            vim.notify("Please provide a problem name", vim.log.levels.ERROR)
            return
        end
        
        local file_path, created = file_manager.get_or_create_cuda_file(problem_name)
        
        if created then
            vim.notify("Created new problem: " .. problem_name, vim.log.levels.INFO)
        else
            vim.notify("Opening existing problem: " .. problem_name, vim.log.levels.INFO)
        end
        
        vim.cmd("edit " .. file_path:absolute())
    end, { 
        desc = "Create or open a LeetGPU problem",
        nargs = 1
    })

    vim.api.nvim_create_user_command("LeetGPUListProblems", function()
        local file_manager = require("leetgpu.cli.file_manager")
        local problems = file_manager.list_problems()
        
        if #problems == 0 then
            vim.notify("No problems found", vim.log.levels.INFO)
            return
        end
        
        local OutputPopup = require("leetgpu.cli.output_popup")
        local popup = OutputPopup:new({ title = "LeetGPU - Problems" })
        popup:mount()
        
        local lines = { "Available Problems:", "" }
        for _, problem in ipairs(problems) do
            table.insert(lines, "  • " .. problem)
        end
        
        popup:set_content(lines)
    end, { desc = "List all LeetGPU problems" })
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
