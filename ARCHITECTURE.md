# LeetGPU CLI Integration Architecture

## Component Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         LeetGPU.nvim                            │
│                     (Main Plugin Entry)                          │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       │ initializes
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                      CLI Keybindings                            │
│              (lua/leetgpu/cli/keybindings.lua)                  │
│  • Auto-setup for CUDA files                                    │
│  • Buffer-local and global keymaps                              │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       │ triggers
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                          Runner                                 │
│                (lua/leetgpu/runner/init.lua)                    │
│  • run_current_buffer()                                         │
│  • run_problem()                                                │
│  • show_cuda_version()                                          │
│  • show_gpus()                                                  │
└──────┬────────────────────────────────┬─────────────────────────┘
       │                                │
       │ uses                           │ uses
       │                                │
       ▼                                ▼
┌──────────────────────┐     ┌─────────────────────────────────┐
│   CLI Interface      │     │     Output Popup                │
│  (cli/init.lua)      │     │  (cli/output_popup.lua)         │
│  • run()             │     │  • mount()                      │
│  • cuda_version()    │     │  • set_content()                │
│  • list_gpus()       │     │  • append_content()             │
│  • upgrade()         │     │  • unmount()                    │
│  • is_installed()    │     └─────────────────────────────────┘
└──────┬───────────────┘
       │
       │ executes
       │
       ▼
┌──────────────────────┐
│   leetgpu CLI        │
│   (External Tool)    │
│  • Functional mode   │
│  • Cycle-accurate    │
│  • GPU simulation    │
└──────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     File Manager                                │
│              (cli/file_manager.lua)                             │
│  • get_problem_dir()                                            │
│  • get_or_create_cuda_file()                                    │
│  • list_problems()                                              │
│  • delete_problem()                                             │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       │ manages
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    ~/.leetgpu/ Directory                        │
│                                                                 │
│  problem_1/                                                     │
│  ├── problem_1.cu                                               │
│  └── (other files)                                              │
│                                                                 │
│  problem_2/                                                     │
│  ├── problem_2.cu                                               │
│  └── (other files)                                              │
└─────────────────────────────────────────────────────────────────┘
```

## User Interaction Flow

### Creating a New Problem

```
User: :LeetGPUNewProblem vector_add
  │
  ▼
Command Handler (command/init.lua)
  │
  ▼
File Manager
  │ creates directory
  │ creates .cu file with template
  ▼
Opens file in Neovim
```

### Running Code

```
User: <leader>lr (in .cu file)
  │
  ▼
Keybinding Handler
  │
  ▼
Runner.run_current_buffer()
  │
  ├─→ Creates Output Popup (shows "Running...")
  │
  ├─→ CLI.run(file_path, opts, callback)
  │     │
  │     ├─→ Checks if CLI installed
  │     │
  │     ├─→ Spawns leetgpu CLI process
  │     │     │
  │     │     ▼
  │     │   leetgpu run file.cu --mode functional
  │     │     │
  │     │     ▼
  │     │   Captures output/errors
  │     │
  │     └─→ Callback with results
  │
  └─→ Updates Output Popup with results
      │
      └─→ Shows ✓ Success or ✗ Error
```

### Viewing Available GPUs

```
User: <leader>lg
  │
  ▼
Keybinding Handler
  │
  ▼
Runner.show_gpus()
  │
  ├─→ Creates Output Popup
  │
  ├─→ CLI.list_gpus(callback)
  │     │
  │     └─→ leetgpu list-gpus
  │
  └─→ Updates popup with GPU list
```

## Configuration Flow

```
User Config
  │
  ▼
config.apply(user_config)
  │
  ▼
config.setup()
  │
  ├─→ Validates configuration
  │
  ├─→ Creates directories
  │
  └─→ Loads CLI settings
      │
      └─→ Used as defaults in Runner
```

## Key Design Principles

### 1. Separation of Concerns
- **CLI Module**: Pure CLI interaction
- **File Manager**: File system operations
- **Runner**: Business logic and coordination
- **Output Popup**: Display and UI
- **Keybindings**: User interaction mapping

### 2. Asynchronous by Default
- All CLI operations use plenary.job
- Non-blocking execution
- Callback-based API
- Responsive UI

### 3. User-Friendly Feedback
- Popup windows for all output
- Clear success/error indicators
- Scrollable content
- Easy dismissal

### 4. Flexible Configuration
- Global defaults in config
- Per-command overrides
- Environment detection
- Graceful degradation

### 5. Modular Architecture
- Each module is independent
- Clear interfaces between modules
- Easy to extend
- Easy to test

## Data Flow Example

### Running a Problem in Cycle-Accurate Mode

```
1. User opens ~/.leetgpu/vector_add/vector_add.cu
   └─→ FileType autocmd triggers
       └─→ Keybindings.setup_cuda_buffer()
           └─→ <leader>lc mapped to cycle-accurate run

2. User presses <leader>lc
   └─→ Runner.run_current_buffer({ mode: "cycle-accurate" })
       │
       ├─→ Gets file path from buffer
       │
       ├─→ Reads config.user.cli.gpu (if set)
       │
       ├─→ Creates OutputPopup:new()
       │   └─→ popup:mount()
       │       └─→ Shows "Running..." message
       │
       └─→ CLI.run(path, { mode: "cycle-accurate", gpu: "NVIDIA GV100" }, callback)
           │
           ├─→ Checks CLI.is_installed()
           │   └─→ If false, shows error in popup and returns
           │
           ├─→ Builds command: ["run", path, "--mode", "cycle-accurate", "--gpu", "NVIDIA GV100"]
           │
           ├─→ Job:new() with command
           │   │
           │   ├─→ on_stdout: Collects output
           │   ├─→ on_stderr: Collects errors
           │   └─→ on_exit: Triggers callback
           │
           └─→ job:start()
               └─→ [Async execution]
                   └─→ Callback invoked with results
                       │
                       └─→ popup:set_title() and popup:set_content()
                           └─→ Displays formatted output/errors

3. User views results in popup
   └─→ Can scroll with j/k
   └─→ Presses 'q' to close
       └─→ popup:unmount()
```

## Error Handling Flow

```
Any Operation
  │
  ├─→ CLI not installed?
  │   └─→ Log error + Show popup with installation instructions
  │
  ├─→ File not found?
  │   └─→ Log error + Show notification
  │
  ├─→ CLI execution failed?
  │   └─→ Capture stderr + Show in popup with error formatting
  │
  └─→ Other error?
      └─→ Log error + Show generic error message
```

## Module Dependencies

```
leetgpu.lua
  └─→ cli.keybindings
      └─→ (No dependencies)

runner/init.lua
  ├─→ cli/init.lua
  │   └─→ plenary.job
  ├─→ cli/file_manager.lua
  │   └─→ plenary.path
  ├─→ cli/output_popup.lua
  │   ├─→ nui.popup
  │   └─→ config
  └─→ config

command/init.lua
  ├─→ cli/file_manager.lua
  ├─→ cli/output_popup.lua
  └─→ runner/init.lua

cli/keybindings.lua
  └─→ runner/init.lua
```

This architecture ensures clean separation of concerns, maintainability, and extensibility while providing a seamless user experience.
