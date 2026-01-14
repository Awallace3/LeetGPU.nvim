# LeetGPU.nvim

A Neovim plugin for [LeetGPU.com](https://leetgpu.com) - practice GPU programming challenges directly in Neovim!

This plugin is modeled after [leetcode.nvim](https://github.com/kawre/leetcode.nvim) but designed specifically for [LeetGPU.com](https://leetgpu.com), a platform for learning and practicing GPU programming with CUDA and other GPU technologies.

## ✨ Features

- 📌 Intuitive dashboard for navigating LeetGPU challenges
- 💻 Support for CUDA, C++, C, and Python
- 🎨 Syntax highlighting and code completion
- 📊 Challenge statistics and difficulty levels
- 💾 Local caching for better performance

## 📬 Requirements

- [Neovim](https://github.com/neovim/neovim) >= 0.9.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [Nerd Font](https://www.nerdfonts.com) (optional, for icons)

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "Awallace3/LeetGPU.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        -- configuration goes here
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
            -- configuration goes here
        })
    end
}
```

## 🛠️ Configuration

### Default Configuration

```lua
{
    ---@type string
    arg = "leetgpu.nvim",

    ---@type string (cuda, cpp, c, python, python3)
    lang = "cuda",

    ---@type table
    storage = {
        home = vim.fn.stdpath("data") .. "/leetgpu",
        cache = vim.fn.stdpath("cache") .. "/leetgpu",
    },

    ---@type boolean
    logging = true,

    console = {
        open_on_runcode = true,
        size = {
            width = "90%",
            height = "75%",
        },
    },

    description = {
        position = "left",
        width = "40%",
        show_stats = true,
    },
}
```

## 🚀 Usage

### Starting LeetGPU.nvim

You can start LeetGPU.nvim in two ways:

1. **As a standalone app**: Launch Neovim with the configured argument
   ```bash
   nvim leetgpu.nvim
   ```

2. **From within Neovim**: Use the command
   ```vim
   :LeetGPU
   ```

### Available Commands

- `:LeetGPU` - Open LeetGPU menu dashboard
- `:LeetGPUMenu` - Same as `:LeetGPU`
- `:LeetGPUExit` - Exit LeetGPU

### Keybindings

Default keybindings in the menu:
- `q` - Close/toggle menu
- `<CR>` - Confirm selection

## 🎯 Getting Started

1. Install the plugin using your preferred plugin manager
2. Configure the plugin in your Neovim config
3. Launch with `:LeetGPU` or `nvim leetgpu.nvim`
4. Start practicing GPU programming challenges!

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project follows the same license as the original leetcode.nvim plugin.

## 🙏 Acknowledgments

This plugin is inspired by and modeled after [leetcode.nvim](https://github.com/kawre/leetcode.nvim) by [@kawre](https://github.com/kawre). Special thanks for the excellent architecture and design patterns.
