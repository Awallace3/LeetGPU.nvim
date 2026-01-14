# CUDA Examples

This directory contains example CUDA programs that can be used with LeetGPU CLI integration.

## vector_add.cu

A simple vector addition kernel that demonstrates:
- Basic CUDA memory management
- Kernel launches with proper grid/block dimensions
- Error checking for CUDA API calls
- Host-device data transfer
- Result verification

### Running with LeetGPU.nvim

1. Open the file in Neovim:
   ```bash
   nvim examples/cuda/vector_add.cu
   ```

2. Run with default settings:
   ```vim
   " Press <leader>lr in normal mode
   ```

3. Or use commands:
   ```vim
   :LeetGPURun
   :LeetGPURun --mode functional
   :LeetGPURun --mode cycle-accurate --gpu "NVIDIA GV100"
   ```

### Expected Output

```
[Vector addition of 50000 elements]
Copy input data from the host memory to the CUDA device
CUDA kernel launch with 196 blocks of 256 threads
Copy output data from the CUDA device to the host memory
Test PASSED
Done
```

## Creating Your Own Problems

Use the plugin to create new problem files:

```vim
:LeetGPUNewProblem my_kernel
```

This will:
- Create `~/.leetgpu/my_kernel/my_kernel.cu`
- Open the file with a default CUDA template
- Allow you to write and test your kernel

## Testing Different Modes

### Functional Mode (Fast)
- Quick execution
- Good for development and debugging
- Tests correctness

```vim
<leader>lf
```

### Cycle-Accurate Mode (Detailed)
- Slower execution
- Provides detailed performance metrics
- Requires GPU specification

```vim
<leader>lc
```

## Additional Resources

- [LeetGPU.com](https://leetgpu.com) - Learn GPU programming
- [LeetGPU CLI](https://leetgpu.com/cli) - Download and install the CLI
- [CUDA Programming Guide](https://docs.nvidia.com/cuda/) - Official CUDA documentation
