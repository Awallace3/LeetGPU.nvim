local log = require("leetgpu.logger")
local Job = require("plenary.job")

---@class lg.CLI
local cli = {}

---Check if leetgpu CLI is installed
---@return boolean
function cli.is_installed()
    local result = vim.fn.executable("leetgpu")
    return result == 1
end

---Get CLI version
---@return string|nil
function cli.get_version()
    if not cli.is_installed() then
        return nil
    end

    local job = Job:new({
        command = "leetgpu",
        args = { "--version" },
        on_exit = function(j, return_val)
            if return_val == 0 then
                local output = table.concat(j:result(), "\n")
                return output
            end
        end,
    })

    job:sync()
    return job:result()[1]
end

---Run CUDA code on simulated GPU
---@param file_path string Path to the .cu file
---@param opts? table Options: mode (functional|cycle-accurate), gpu (GPU name)
---@param callback? function Callback function(success, output, error)
function cli.run(file_path, opts, callback)
    opts = opts or {}
    local mode = opts.mode or "functional"
    local gpu = opts.gpu

    if not cli.is_installed() then
        local err = "leetgpu CLI is not installed. Install from https://leetgpu.com/cli"
        log.error(err)
        if callback then
            callback(false, nil, err)
        end
        return
    end

    local args = { "run", file_path, "--mode", mode }
    if gpu then
        table.insert(args, "--gpu")
        table.insert(args, gpu)
    end

    log.info("Running: leetgpu " .. table.concat(args, " "))

    local output_lines = {}
    local error_lines = {}

    local job = Job:new({
        command = "leetgpu",
        args = args,
        on_stdout = function(_, data)
            table.insert(output_lines, data)
        end,
        on_stderr = function(_, data)
            table.insert(error_lines, data)
        end,
        on_exit = function(j, return_val)
            local output = table.concat(output_lines, "\n")
            local error = table.concat(error_lines, "\n")
            
            if return_val == 0 then
                log.info("leetgpu run completed successfully")
                if callback then
                    callback(true, output, nil)
                end
            else
                log.error("leetgpu run failed with exit code: " .. return_val)
                if callback then
                    callback(false, output, error)
                end
            end
        end,
    })

    job:start()
    return job
end

---Get CUDA version for specified mode
---@param mode? string "functional" or "cycle-accurate"
---@param callback? function Callback function(success, output, error)
function cli.cuda_version(mode, callback)
    mode = mode or "functional"

    if not cli.is_installed() then
        local err = "leetgpu CLI is not installed. Install from https://leetgpu.com/cli"
        log.error(err)
        if callback then
            callback(false, nil, err)
        end
        return
    end

    local args = { "cuda-version", "--mode", mode }
    log.info("Running: leetgpu " .. table.concat(args, " "))

    local job = Job:new({
        command = "leetgpu",
        args = args,
        on_exit = function(j, return_val)
            if return_val == 0 then
                local output = table.concat(j:result(), "\n")
                log.info("CUDA version: " .. output)
                if callback then
                    callback(true, output, nil)
                end
            else
                local error = table.concat(j:stderr_result(), "\n")
                log.error("Failed to get CUDA version: " .. error)
                if callback then
                    callback(false, nil, error)
                end
            end
        end,
    })

    job:sync()
end

---List available GPUs
---@param callback? function Callback function(success, output, error)
function cli.list_gpus(callback)
    if not cli.is_installed() then
        local err = "leetgpu CLI is not installed. Install from https://leetgpu.com/cli"
        log.error(err)
        if callback then
            callback(false, nil, err)
        end
        return
    end

    local args = { "list-gpus" }
    log.info("Running: leetgpu " .. table.concat(args, " "))

    local job = Job:new({
        command = "leetgpu",
        args = args,
        on_exit = function(j, return_val)
            if return_val == 0 then
                local output = table.concat(j:result(), "\n")
                log.info("Available GPUs:\n" .. output)
                if callback then
                    callback(true, output, nil)
                end
            else
                local error = table.concat(j:stderr_result(), "\n")
                log.error("Failed to list GPUs: " .. error)
                if callback then
                    callback(false, nil, error)
                end
            end
        end,
    })

    job:sync()
end

---Upgrade CLI to latest version
---@param callback? function Callback function(success, output, error)
function cli.upgrade(callback)
    if not cli.is_installed() then
        local err = "leetgpu CLI is not installed. Install from https://leetgpu.com/cli"
        log.error(err)
        if callback then
            callback(false, nil, err)
        end
        return
    end

    local args = { "upgrade" }
    log.info("Running: leetgpu " .. table.concat(args, " "))

    local job = Job:new({
        command = "leetgpu",
        args = args,
        on_exit = function(j, return_val)
            if return_val == 0 then
                local output = table.concat(j:result(), "\n")
                log.info("CLI upgrade completed: " .. output)
                if callback then
                    callback(true, output, nil)
                end
            else
                local error = table.concat(j:stderr_result(), "\n")
                log.error("Failed to upgrade CLI: " .. error)
                if callback then
                    callback(false, nil, error)
                end
            end
        end,
    })

    job:sync()
end

return cli
