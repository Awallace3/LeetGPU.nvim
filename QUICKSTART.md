# Quick Start Guide - LeetGPU CLI Integration

Get up and running with LeetGPU CLI integration in 5 minutes!

## Prerequisites

1. **Install Neovim** (>= 0.9.0)
   ```bash
   nvim --version  # Check your version
   ```

2. **Install LeetGPU.nvim dependencies**
   - [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
   - [nui.nvim](https://github.com/MunifTanjim/nui.nvim)

3. **Install LeetGPU CLI** (optional but recommended)
   ```bash
   # Visit https://leetgpu.com/cli for installation instructions
   leetgpu --version  # Verify installation
   ```

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "Awallace3/LeetGPU.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        lang = "cuda",
        cli = {
            mode = "functional",  -- or "cycle-accurate"
            gpu = nil,           -- e.g., "NVIDIA GV100" for cycle-accurate
        },
    },
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'Awallace3/LeetGPU.nvim',
    requires = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
    },
    config = function()
        require('leetgpu').setup({
            lang = "cuda",
            cli = {
                mode = "functional",
                gpu = nil,
            },
        })
    end
}
```

## Your First Problem

### Step 1: Create a Problem

```vim
:LeetGPUNewProblem hello_cuda
```

This creates:
- Directory: `~/.leetgpu/hello_cuda/`
- File: `~/.leetgpu/hello_cuda/hello_cuda.cu`
- Opens the file in Neovim with a CUDA template

### Step 2: Write Your CUDA Code

Replace the template with this simple example:

```cuda
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void hello() {
    printf("Hello from GPU thread %d!\n", threadIdx.x);
}

int main() {
    printf("Starting CUDA...\n");
    hello<<<1, 10>>>();
    cudaDeviceSynchronize();
    printf("Done!\n");
    return 0;
}
```

### Step 3: Run Your Code

**Option 1: Use keybinding** (fastest)
```
Press: <leader>lr
```

**Option 2: Use command**
```vim
:LeetGPURun
```

**Option 3: Run in different mode**
```
Press: <leader>lf  (functional mode - fast)
Press: <leader>lc  (cycle-accurate mode - detailed)
```

### Step 4: View Results

A popup window appears with your output:

```
✓ Execution completed successfully!

Output:

Starting CUDA...
Hello from GPU thread 0!
Hello from GPU thread 1!
Hello from GPU thread 2!
...
Done!
```

Press `q` to close the popup.

## Common Tasks

### List All Your Problems

```vim
:LeetGPUListProblems
```
or press `<leader>lp`

### Check CUDA Version

```vim
:LeetGPUCudaVersion functional
```
or press `<leader>lv`

### List Available GPUs

```vim
:LeetGPUListGpus
```
or press `<leader>lg`

### Run with Specific GPU

```vim
:LeetGPURun --mode cycle-accurate --gpu "NVIDIA GV100"
```

### Open the Menu

```vim
:LeetGPUMenu
```
or press `<leader>lm`

## Keybinding Cheat Sheet

| Key | Action | Mode |
|-----|--------|------|
| `<leader>lr` | Run with default settings | Normal |
| `<leader>lf` | Run in functional mode | Normal |
| `<leader>lc` | Run in cycle-accurate mode | Normal |
| `<leader>lv` | Show CUDA version | Normal |
| `<leader>lg` | List GPUs | Normal |
| `<leader>lm` | Open menu | Normal |
| `<leader>lp` | List problems | Normal |
| `q` | Close popup | In popup |
| `j`/`k` | Scroll | In popup |
| `gg`/`G` | Top/Bottom | In popup |

*Note: Keybindings automatically work in `.cu` files*

## Try the Example

Open the included example:

```bash
cd ~/.local/share/nvim/lazy/LeetGPU.nvim  # or your plugin directory
nvim examples/cuda/vector_add.cu
```

Then press `<leader>lr` to run it!

## Troubleshooting

### "leetgpu CLI is not installed"

Install the CLI:
1. Visit https://leetgpu.com/cli
2. Follow installation instructions
3. Verify: `leetgpu --version`

### Keybindings don't work

1. Check if you're in a `.cu` file: `:set filetype?` should show `cuda`
2. If not, set it: `:set filetype=cuda`
3. Reload the file: `:e`

### Commands not found

Verify plugin is loaded:
```vim
:echo exists(':LeetGPURun')
```
Should return `2`. If not, check your plugin manager config.

### Popup won't close

Press `q` or use `:q` if focus is in the popup buffer.

## Configuration Tips

### Always use cycle-accurate mode

```lua
opts = {
    cli = {
        mode = "cycle-accurate",
        gpu = "NVIDIA GV100",
    },
}
```

### Change keybinding prefix

Currently uses `<leader>l*`. To change, modify `lua/leetgpu/cli/keybindings.lua`.

### Disable auto-keybindings

Comment out the keybinding setup in your config and manually map:

```lua
vim.keymap.set("n", "<leader>r", function()
    require("leetgpu.runner").run_current_buffer()
end, { desc = "Run CUDA code" })
```

## Next Steps

1. **Read the full documentation**: See `doc/configuration.md` for all options
2. **Check the examples**: Browse `examples/cuda/` for more examples
3. **Join the community**: Visit [LeetGPU.com](https://leetgpu.com)
4. **Learn CUDA**: Practice GPU programming challenges

## Getting Help

- **Documentation**: `:help leetgpu` (coming soon)
- **Issues**: https://github.com/Awallace3/LeetGPU.nvim/issues
- **Discussions**: https://github.com/Awallace3/LeetGPU.nvim/discussions

## Useful Commands Reference

```vim
" Problem Management
:LeetGPUNewProblem <name>    " Create new problem
:LeetGPUListProblems         " List all problems

" Running Code
:LeetGPURun                  " Run current file
:LeetGPURun --mode functional              " Specify mode
:LeetGPURun --mode cycle-accurate --gpu "NVIDIA GV100"  " With GPU

" CLI Information
:LeetGPUCudaVersion          " Show CUDA version
:LeetGPUCudaVersion cycle-accurate  " Version for specific mode
:LeetGPUListGpus             " List available GPUs

" Navigation
:LeetGPUMenu                 " Open menu
:LeetGPUExit                 " Exit LeetGPU
```

Happy GPU programming! 🚀
