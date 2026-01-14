# LeetGPU CLI Integration - Feature Overview

## 🎯 What You Can Do

### 1. Create and Manage Problems

```vim
" Create a new problem
:LeetGPUNewProblem matrix_multiply

" List all your problems
:LeetGPUListProblems

" Or press <leader>lp
```

**Result:** Problems organized in `~/.leetgpu/<problem_name>/` with automatic CUDA templates.

---

### 2. Run Code with One Keypress

```vim
" In a .cu file, just press:
<leader>lr
```

**Result:** Popup window shows execution output instantly!

```
┌─ LeetGPU - Success ─────────────────────────┐
│ ✓ Execution completed successfully!        │
│                                             │
│ Output:                                     │
│                                             │
│ [Vector addition of 50000 elements]         │
│ Copy input data from host to device        │
│ CUDA kernel launch with 196 blocks         │
│ Test PASSED                                 │
│ Done                                        │
│                                             │
│ Press 'q' to close                          │
└─────────────────────────────────────────────┘
```

---

### 3. Test in Different Modes

**Functional Mode** - Fast execution for development:
```vim
<leader>lf
```

**Cycle-Accurate Mode** - Detailed simulation with specific GPU:
```vim
<leader>lc
```

**Result:** Choose speed vs. detail based on your needs!

---

### 4. Check CUDA Environment

```vim
" Show CUDA version
:LeetGPUCudaVersion
" Or press <leader>lv

" List available GPUs
:LeetGPUListGpus
" Or press <leader>lg
```

**Result:** See what CUDA version and GPUs are available for testing.

---

### 5. Configure Defaults

```lua
require('leetgpu').setup({
    cli = {
        mode = "functional",     -- Default to fast mode
        gpu = "NVIDIA GV100",    -- Default GPU for cycle-accurate
    },
})
```

**Result:** Set your preferred defaults, override when needed.

---

## 🎨 Visual Workflow

```
┌──────────────────────┐
│ Create Problem       │
│ :LeetGPUNewProblem   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Write CUDA Code      │
│ (in .cu file)        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Run Code             │
│ Press <leader>lr     │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ View Results         │
│ (Beautiful Popup)    │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Iterate & Improve    │
└──────────────────────┘
```

---

## ⌨️ Keyboard Shortcuts

| What You Want | What You Press | What Happens |
|--------------|----------------|--------------|
| Run my code now! | `<leader>lr` | Runs with default settings |
| Fast test | `<leader>lf` | Functional mode (quick) |
| Detailed analysis | `<leader>lc` | Cycle-accurate (slow but detailed) |
| What CUDA? | `<leader>lv` | Shows CUDA version |
| What GPUs? | `<leader>lg` | Lists available GPUs |
| See my problems | `<leader>lp` | Shows all problems |
| Open menu | `<leader>lm` | Opens LeetGPU menu |

*All keybindings work automatically in `.cu` files!*

---

## 📁 File Organization

```
~/.leetgpu/
├── vector_add/
│   └── vector_add.cu          ← Your code here
│
├── matrix_multiply/
│   └── matrix_multiply.cu     ← Another problem
│
└── parallel_reduction/
    └── parallel_reduction.cu  ← And another!
```

Each problem gets its own clean workspace!

---

## 🎓 Example Session

```bash
# 1. Open Neovim
nvim

# 2. Create a problem
:LeetGPUNewProblem hello_gpu

# 3. Write this code:
```

```cuda
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void hello() {
    printf("Hello from thread %d\n", threadIdx.x);
}

int main() {
    hello<<<1, 5>>>();
    cudaDeviceSynchronize();
    return 0;
}
```

```bash
# 4. Run it
Press: <leader>lr

# 5. See output in popup:
Hello from thread 0
Hello from thread 1
Hello from thread 2
Hello from thread 3
Hello from thread 4

# 6. Success! 🎉
```

---

## 💪 Power User Features

### Run with Custom Settings

```vim
:LeetGPURun --mode cycle-accurate --gpu "NVIDIA GV100"
```

### Check Multiple Modes

```vim
" Functional mode CUDA version
:LeetGPUCudaVersion functional

" Cycle-accurate mode CUDA version
:LeetGPUCudaVersion cycle-accurate
```

### Configure Per-Project

```lua
-- In your project's .nvimrc or .exrc
require('leetgpu').setup({
    cli = {
        mode = "cycle-accurate",
        gpu = "NVIDIA RTX 2080",
    },
})
```

---

## 🚀 Why It's Awesome

### ✨ Zero Configuration
- Works out of the box
- Smart defaults
- Auto-detects `.cu` files

### ⚡ Lightning Fast
- One keypress to run
- Asynchronous execution
- Neovim stays responsive

### 🎨 Beautiful Output
- Popup windows for all output
- Clear success/error indicators
- Scrollable content
- Vim-like navigation

### 📦 Well Organized
- Each problem isolated
- Clean directory structure
- Easy to find your work

### 🔧 Highly Configurable
- Global defaults
- Per-command overrides
- Per-project settings

### 🛡️ Robust
- Comprehensive error handling
- Helpful error messages
- Graceful degradation

---

## 🎯 Perfect For

- **Learning CUDA** - Quick feedback loop
- **Problem Solving** - Test solutions instantly
- **Development** - Rapid prototyping
- **Testing** - Multiple simulation modes
- **Practice** - Organized workspace

---

## 📚 Learn More

- **QUICKSTART.md** - Get started in 5 minutes
- **TESTING.md** - Test all features
- **doc/configuration.md** - All configuration options
- **doc/api.md** - Complete API reference
- **examples/cuda/** - Working examples

---

## 🆘 Need Help?

```vim
" If CLI not found:
" Install from https://leetgpu.com/cli

" If keybindings don't work:
:set filetype=cuda

" If commands not found:
" Check your plugin manager config
```

---

## 🎉 Start Using It Now!

```vim
:LeetGPUNewProblem my_first_kernel
<leader>lr
```

Happy GPU programming! 🚀
