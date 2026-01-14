# LeetGPU.nvim Configuration Guide

## Basic Setup

Here's a basic configuration for LeetGPU.nvim using lazy.nvim:

```lua
{
    "Awallace3/LeetGPU.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        -- Default language for challenges
        lang = "cuda",
        
        -- Storage directories
        storage = {
            home = vim.fn.stdpath("data") .. "/leetgpu",
            cache = vim.fn.stdpath("cache") .. "/leetgpu",
        },
        
        -- Enable logging
        logging = true,
    },
}
```

## Advanced Configuration

### Custom Language Settings

```lua
opts = {
    lang = "cuda", -- Default language
    
    -- Inject custom imports or code
    injector = {
        ["cuda"] = {
            imports = {
                "#include <cuda_runtime.h>",
                "#include <stdio.h>",
                "#include <helper_cuda.h>",
            },
            after = {
                "// Helper functions",
                "void checkCudaError(cudaError_t error) {",
                "    if (error != cudaSuccess) {",
                "        printf(\"CUDA error: %s\\n\", cudaGetErrorString(error));",
                "    }",
                "}",
            },
        },
        ["cpp"] = {
            imports = {
                "#include <iostream>",
                "#include <vector>",
                "#include <algorithm>",
            },
        },
    },
}
```

### UI Customization

```lua
opts = {
    -- Console settings
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
    
    -- Description panel
    description = {
        position = "left", -- or "right", "top", "bottom"
        width = "40%",
        show_stats = true,
    },
    
    -- Custom theme
    theme = {
        ["normal"] = { fg = "#FFFFFF" },
        ["LgEasy"] = { fg = "#00FF00" },
        ["LgMedium"] = { fg = "#FFA500" },
        ["LgHard"] = { fg = "#FF0000" },
        ["LgTitle"] = { fg = "#00FFFF", bold = true },
    },
}
```

### Hooks

Execute custom functions on specific events:

```lua
opts = {
    hooks = {
        -- Called when entering LeetGPU
        ["enter"] = {
            function()
                print("Welcome to LeetGPU!")
            end,
        },
        
        -- Called when opening a challenge
        ["challenge_enter"] = {
            function(challenge)
                print("Opening challenge: " .. challenge.title)
            end,
        },
        
        -- Called when leaving LeetGPU
        ["leave"] = {
            function()
                print("Goodbye!")
            end,
        },
    },
}
```

### Key Mappings

```lua
opts = {
    keys = {
        toggle = { "q" },        -- Close/toggle menu
        confirm = { "<CR>" },    -- Confirm selection
        reset_testcases = "r",   -- Reset test cases
        use_testcase = "U",      -- Use specific test case
        focus_testcases = "H",   -- Focus test cases panel
        focus_result = "L",      -- Focus result panel
    },
}
```

## Supported Languages

LeetGPU.nvim supports the following languages:

- `cuda` - CUDA C++ (default)
- `cpp` - C++
- `c` - C
- `python` - Python 2
- `python3` - Python 3

## Commands

### Available Commands

- `:LeetGPU [cmd]` - Main command interface
  - `:LeetGPU menu` - Open menu dashboard (default)
  - `:LeetGPU exit` - Exit LeetGPU
- `:LeetGPUMenu` - Direct menu access
- `:LeetGPUExit` - Direct exit

## Picker Integration

LeetGPU.nvim can integrate with various picker plugins:

```lua
opts = {
    picker = {
        provider = "telescope", -- or "fzf-lua", "snacks-picker", "mini-picker"
    },
}
```

If no provider is specified, LeetGPU will auto-detect available pickers.

## Complete Example

Here's a complete configuration example:

```lua
return {
    "Awallace3/LeetGPU.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim", -- Optional: for picker
    },
    opts = {
        arg = "leetgpu.nvim",
        lang = "cuda",
        
        storage = {
            home = vim.fn.stdpath("data") .. "/leetgpu",
            cache = vim.fn.stdpath("cache") .. "/leetgpu",
        },
        
        logging = true,
        
        injector = {
            ["cuda"] = {
                imports = {
                    "#include <cuda_runtime.h>",
                    "#include <stdio.h>",
                },
            },
        },
        
        console = {
            open_on_runcode = true,
            dir = "row",
            size = { width = "90%", height = "75%" },
        },
        
        description = {
            position = "left",
            width = "40%",
            show_stats = true,
        },
        
        picker = {
            provider = "telescope",
        },
        
        theme = {},
        
        hooks = {
            ["enter"] = {},
            ["challenge_enter"] = {},
            ["leave"] = {},
        },
        
        keys = {
            toggle = { "q" },
            confirm = { "<CR>" },
            reset_testcases = "r",
            use_testcase = "U",
            focus_testcases = "H",
            focus_result = "L",
        },
    },
}
```

## Troubleshooting

### Common Issues

1. **Plugin not loading**: Ensure all dependencies (plenary.nvim, nui.nvim) are installed
2. **Commands not available**: Make sure you've called `require('leetgpu').setup()` or used lazy.nvim's `opts`
3. **Picker not working**: Install one of the supported picker plugins (telescope, fzf-lua, etc.)

### Debug Mode

Enable debug logging to troubleshoot issues:

```lua
opts = {
    debug = true,
    logging = true,
}
```

## Contributing

Found a bug or want to contribute? Visit the [GitHub repository](https://github.com/Awallace3/LeetGPU.nvim).
