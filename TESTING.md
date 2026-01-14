# LeetGPU CLI Integration Testing Guide

## Overview

This document describes how to test the newly integrated LeetGPU CLI functionality in LeetGPU.nvim.

## Prerequisites

1. Install LeetGPU CLI from https://leetgpu.com/cli
2. Verify installation: `leetgpu --version`
3. Have Neovim >= 0.9.0 installed with plenary.nvim and nui.nvim

## Feature Testing

### 1. Creating a New Problem

```vim
:LeetGPUNewProblem vector_add
```

**Expected behavior:**
- Creates directory `~/.leetgpu/vector_add/`
- Creates file `~/.leetgpu/vector_add/vector_add.cu` with default CUDA template
- Opens the file in Neovim
- Displays notification: "Created new problem: vector_add"

### 2. Running Code with Default Settings

In a `.cu` file, press `<leader>lr` or run:

```vim
:LeetGPURun
```

**Expected behavior:**
- Popup window appears with title "LeetGPU - Running..."
- Shows file path, mode (functional), and status
- After execution:
  - On success: Shows "✓ Execution completed successfully!" with output
  - On failure: Shows "✗ Execution failed!" with error details
- Popup can be closed with `q`

### 3. Running in Functional Mode

Press `<leader>lf` or:

```vim
:LeetGPURun --mode functional
```

**Expected behavior:**
- Same as above, explicitly using functional mode
- Faster execution, less detailed simulation

### 4. Running in Cycle-Accurate Mode

Press `<leader>lc` or:

```vim
:LeetGPURun --mode cycle-accurate --gpu "NVIDIA GV100"
```

**Expected behavior:**
- Same popup behavior
- More detailed simulation with specific GPU model
- Slower execution but more accurate performance metrics

### 5. Checking CUDA Version

Press `<leader>lv` or:

```vim
:LeetGPUCudaVersion functional
```

**Expected behavior:**
- Popup shows CUDA version information for the specified mode
- Title: "LeetGPU - CUDA Version (functional)"
- Displays CUDA version details

### 6. Listing Available GPUs

Press `<leader>lg` or:

```vim
:LeetGPUListGpus
```

**Expected behavior:**
- Popup shows list of available GPU options
- Title: "LeetGPU - Available GPUs"
- Lists all GPU models supported for cycle-accurate mode

### 7. Listing All Problems

Press `<leader>lp` or:

```vim
:LeetGPUListProblems
```

**Expected behavior:**
- Popup shows all problems in `~/.leetgpu/`
- Each problem listed with a bullet point
- If no problems exist, shows notification: "No problems found"

### 8. Opening LeetGPU Menu

Press `<leader>lm` or:

```vim
:LeetGPUMenu
```

**Expected behavior:**
- Opens the main LeetGPU menu popup
- Shows welcome message and available commands

## Configuration Testing

### Default Configuration

```lua
require('leetgpu').setup({
    cli = {
        mode = "functional",
        gpu = nil,
    },
})
```

### Cycle-Accurate Configuration

```lua
require('leetgpu').setup({
    cli = {
        mode = "cycle-accurate",
        gpu = "NVIDIA GV100",
    },
})
```

## Integration Testing

### Test Scenario 1: Complete Workflow

1. Create a new problem: `:LeetGPUNewProblem matrix_mult`
2. Write CUDA code in the opened file
3. Run with `<leader>lr` to test in functional mode
4. If successful, run with `<leader>lc` for detailed analysis
5. View results in popup windows

### Test Scenario 2: Multiple Problems

1. Create multiple problems:
   - `:LeetGPUNewProblem vector_add`
   - `:LeetGPUNewProblem matrix_mult`
   - `:LeetGPUNewProblem reduction`
2. List problems: `<leader>lp`
3. Navigate to each problem directory
4. Run each problem independently

### Test Scenario 3: Error Handling

1. Create a problem with syntax errors
2. Run with `<leader>lr`
3. Verify error output is displayed in popup
4. Fix errors and rerun
5. Verify success output

## File Structure Verification

After creating problems, verify the directory structure:

```
~/.leetgpu/
├── vector_add/
│   └── vector_add.cu
├── matrix_mult/
│   └── matrix_mult.cu
└── reduction/
    └── reduction.cu
```

## Keybinding Quick Reference

When editing `.cu` files:

- `<leader>lr` - Run with default settings
- `<leader>lf` - Run in functional mode
- `<leader>lc` - Run in cycle-accurate mode
- `<leader>lv` - Show CUDA version
- `<leader>lg` - List GPUs
- `<leader>lm` - Open menu
- `<leader>lp` - List problems

In popups:

- `q` - Close popup
- `j`/`k` - Scroll down/up
- `<C-d>`/`<C-u>` - Page down/up
- `gg`/`G` - Go to top/bottom

## Expected CLI Behavior

### Without leetgpu CLI installed:

- All commands should show error notification: "leetgpu CLI is not installed. Install from https://leetgpu.com/cli"
- Popup should display installation instructions

### With leetgpu CLI installed:

- Commands should execute successfully
- Output should be captured and displayed in popup
- Errors should be properly formatted and shown

## Common Issues and Solutions

### Issue: Commands not found
**Solution:** Verify plugin is loaded: `:checkhealth leetgpu`

### Issue: Keybindings not working
**Solution:** Verify filetype is set: `:set filetype?` should show `cuda`

### Issue: CLI not found
**Solution:** Install CLI from https://leetgpu.com/cli and verify with `leetgpu --version`

### Issue: Popup not closing
**Solution:** Press `q` or use `:q` if in popup buffer

## Developer Notes

### Module Structure

```
lua/leetgpu/cli/
├── init.lua          # CLI command execution
├── file_manager.lua  # Problem file management
├── output_popup.lua  # Output display window
└── keybindings.lua   # Keybinding setup
```

### Key Functions

- `cli.run()` - Execute leetgpu CLI with options
- `file_manager.get_or_create_cuda_file()` - Manage problem files
- `OutputPopup:new()` - Create result display
- `runner.run_current_buffer()` - Main entry point for execution

## Future Enhancements

Potential improvements:
1. Real-time output streaming during execution
2. Multiple file support per problem
3. Test case management
4. Performance metrics visualization
5. GPU comparison mode
6. History tracking of runs
7. Custom keybinding configuration
