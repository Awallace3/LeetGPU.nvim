local config = require("leetgpu.config")

---@class lg.Keybindings
local keybindings = {}

---Setup buffer-local keybindings for CUDA files
---@param bufnr number
function keybindings.setup_cuda_buffer(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Run code with default settings
    vim.keymap.set("n", "<leader>lr", function()
        require("leetgpu.runner").run_current_buffer()
    end, vim.tbl_extend("force", opts, { desc = "Run with LeetGPU CLI" }))
    
    -- Run code in functional mode
    vim.keymap.set("n", "<leader>lf", function()
        require("leetgpu.runner").run_current_buffer({ mode = "functional" })
    end, vim.tbl_extend("force", opts, { desc = "Run in functional mode" }))
    
    -- Run code in cycle-accurate mode
    vim.keymap.set("n", "<leader>lc", function()
        require("leetgpu.runner").run_current_buffer({ mode = "cycle-accurate" })
    end, vim.tbl_extend("force", opts, { desc = "Run in cycle-accurate mode" }))
    
    -- Show CUDA version
    vim.keymap.set("n", "<leader>lv", function()
        require("leetgpu.runner").show_cuda_version()
    end, vim.tbl_extend("force", opts, { desc = "Show CUDA version" }))
    
    -- List GPUs
    vim.keymap.set("n", "<leader>lg", function()
        require("leetgpu.runner").show_gpus()
    end, vim.tbl_extend("force", opts, { desc = "List available GPUs" }))
end

---Setup global keybindings
function keybindings.setup_global()
    local opts = { noremap = true, silent = true }
    
    -- Open LeetGPU menu
    vim.keymap.set("n", "<leader>lm", function()
        require("leetgpu-ui.renderer.menu"):new():mount()
    end, vim.tbl_extend("force", opts, { desc = "Open LeetGPU menu" }))
    
    -- List problems
    vim.keymap.set("n", "<leader>lp", function()
        vim.cmd("LeetGPUListProblems")
    end, vim.tbl_extend("force", opts, { desc = "List LeetGPU problems" }))
end

---Auto-setup keybindings for CUDA files
function keybindings.setup_autocommands()
    local group = vim.api.nvim_create_augroup("LeetGPUKeybindings", { clear = true })
    
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "cuda",
        callback = function(ev)
            keybindings.setup_cuda_buffer(ev.buf)
        end,
    })
    
    -- Also setup for .cu files that might not have filetype set
    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = "*.cu",
        callback = function(ev)
            -- Set filetype if not already set
            if vim.bo[ev.buf].filetype == "" then
                vim.bo[ev.buf].filetype = "cuda"
            end
            keybindings.setup_cuda_buffer(ev.buf)
        end,
    })
end

return keybindings
