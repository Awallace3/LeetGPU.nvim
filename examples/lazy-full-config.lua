-- Example configuration for LeetGPU.nvim
-- This file shows various configuration options

return {
    "Awallace3/LeetGPU.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        -- Optional: Add your preferred picker
        -- "nvim-telescope/telescope.nvim",
        -- "ibhagwan/fzf-lua",
    },
    opts = {
        -- Startup argument (used when launching nvim with this arg)
        arg = "leetgpu.nvim",

        -- Default programming language
        lang = "cuda",

        -- Storage directories
        storage = {
            home = vim.fn.stdpath("data") .. "/leetgpu",
            cache = vim.fn.stdpath("cache") .. "/leetgpu",
        },

        -- Plugin behavior
        plugins = {
            non_standalone = false, -- Allow running in non-standalone mode
        },

        -- Enable logging
        logging = true,

        -- Code injection (add imports, helper code, etc.)
        injector = {
            ["cuda"] = {
                imports = {
                    "#include <cuda_runtime.h>",
                    "#include <stdio.h>",
                },
                after = {
                    "// Add helper functions here",
                },
            },
            ["cpp"] = {
                imports = {
                    "#include <iostream>",
                    "#include <vector>",
                },
            },
        },

        -- Cache settings
        cache = {
            update_interval = 60 * 60 * 24 * 7, -- 7 days in seconds
        },

        -- Editor behavior
        editor = {
            reset_previous_code = true,
            fold_imports = true,
        },

        -- Console/output panel settings
        console = {
            open_on_runcode = true,
            dir = "row", -- or "col"
            size = {
                width = "90%",
                height = "75%",
            },
            result = {
                size = "60%",
            },
            testcase = {
                virt_text = true,
                size = "40%",
            },
        },

        -- Description panel settings
        description = {
            position = "left", -- or "right", "top", "bottom"
            width = "40%",
            show_stats = true,
        },

        -- Picker configuration
        picker = {
            provider = nil, -- Auto-detect, or specify: "telescope", "fzf-lua", etc.
        },

        -- Event hooks
        hooks = {
            -- Called when entering LeetGPU
            ["enter"] = {
                function()
                    vim.notify("Welcome to LeetGPU!", vim.log.levels.INFO)
                end,
            },

            -- Called when opening a challenge
            ["challenge_enter"] = {
                function(challenge)
                    local msg = string.format("Opening: %s [%s]", challenge.title, challenge.difficulty)
                    vim.notify(msg, vim.log.levels.INFO)
                end,
            },

            -- Called when leaving LeetGPU
            ["leave"] = {
                function()
                    vim.notify("Goodbye from LeetGPU!", vim.log.levels.INFO)
                end,
            },
        },

        -- Key mappings
        keys = {
            toggle = { "q" },
            confirm = { "<CR>" },
            reset_testcases = "r",
            use_testcase = "U",
            focus_testcases = "H",
            focus_result = "L",
        },

        -- Custom theme colors
        theme = {
            ["normal"] = { fg = "#FFFFFF" },
            ["alt"] = { fg = "#D0D0D0" },
            ["LgEasy"] = { fg = "#00FF00" },
            ["LgMedium"] = { fg = "#FFA500" },
            ["LgHard"] = { fg = "#FF0000" },
            ["LgTitle"] = { fg = "#00FFFF", bold = true },
            ["LgHeader"] = { fg = "#FFFF00", bold = true },
        },

        -- CLI settings
        cli = {
            mode = "functional", -- or "cycle-accurate"
            gpu = nil, -- e.g., "NVIDIA GV100" for cycle-accurate mode
        },

        -- Image support (requires image.nvim)
        image_support = false,
    },
}
