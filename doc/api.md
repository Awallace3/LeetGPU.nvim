# LeetGPU.nvim API Documentation

## Module Structure

LeetGPU.nvim is organized into several modules:

### Core Modules

- `leetgpu` - Main entry point
- `leetgpu.config` - Configuration management
- `leetgpu.logger` - Logging utilities
- `leetgpu.utils` - General utilities

### Feature Modules

- `leetgpu.api` - API client for LeetGPU.com
- `leetgpu.cache` - Local data caching
- `leetgpu.parser` - Challenge data parsing
- `leetgpu.runner` - Code execution
- `leetgpu.picker` - Challenge picker integration
- `leetgpu.command` - Command handlers
- `leetgpu.theme` - UI theming

### UI Modules

- `leetgpu-ui.renderer` - UI renderers
- `leetgpu-ui.utils` - UI utilities
- `leetgpu-ui.types` - Type definitions

## API Reference

### Main Module (leetgpu)

#### `setup(cfg)`

Initialize LeetGPU.nvim with configuration.

**Parameters:**
- `cfg` (table, optional): Configuration options

**Example:**
```lua
require('leetgpu').setup({
    lang = "cuda",
    logging = true,
})
```

#### `start(on_vimenter)`

Start LeetGPU session.

**Parameters:**
- `on_vimenter` (boolean): Whether called from VimEnter event

**Returns:**
- `boolean`: Success status

#### `stop()`

Exit LeetGPU and quit Neovim.

### Configuration Module (leetgpu.config)

#### `apply(cfg)`

Apply user configuration.

**Parameters:**
- `cfg` (table): Configuration to merge with defaults

#### `setup()`

Setup configuration and storage directories.

#### `validate()`

Validate configuration settings.

### API Module (leetgpu.api)

#### URL Constants

Available in `leetgpu.api.urls`:

```lua
urls.base = "https://leetgpu.com"
urls.challenges = "/api/challenges/"
urls.challenge = "/api/challenges/%s/"
urls.submit = "/api/challenges/%s/submit/"
urls.run = "/api/challenges/%s/run/"
urls.check = "/api/submissions/%s/"
urls.leaderboard = "/api/leaderboard/"
```

#### `challenges.list()`

Get list of all challenges.

**Returns:**
- `table|nil`: Challenge list or nil on error
- `string|nil`: Error message if failed

#### `challenges.get(id)`

Get specific challenge by ID.

**Parameters:**
- `id` (string): Challenge ID

**Returns:**
- `table|nil`: Challenge data or nil on error
- `string|nil`: Error message if failed

#### `challenges.submit(id, code, lang)`

Submit solution for a challenge.

**Parameters:**
- `id` (string): Challenge ID
- `code` (string): Solution code
- `lang` (string): Programming language

**Returns:**
- `table|nil`: Submission result or nil on error
- `string|nil`: Error message if failed

### Cache Module (leetgpu.cache)

#### `read(name)`

Read data from cache.

**Parameters:**
- `name` (string): Cache key

**Returns:**
- `table|nil`: Cached data or nil if not found

#### `write(name, data)`

Write data to cache.

**Parameters:**
- `name` (string): Cache key
- `data` (table): Data to cache

**Returns:**
- `boolean`: Success status

#### `clear(name)`

Clear cache.

**Parameters:**
- `name` (string, optional): Cache key to clear. If nil, clears all cache.

### Parser Module (leetgpu.parser)

#### `html_to_text(html)`

Convert HTML to plain text.

**Parameters:**
- `html` (string): HTML content

**Returns:**
- `string`: Plain text content

#### `parse_challenge(data)`

Parse challenge data from API response.

**Parameters:**
- `data` (table): Raw challenge data

**Returns:**
- `lg.ui.Challenge`: Parsed challenge object

### Runner Module (leetgpu.runner)

#### `run(code, lang, test_cases)`

Run code with test cases.

**Parameters:**
- `code` (string): Code to run
- `lang` (string): Programming language
- `test_cases` (table, optional): Test cases

**Returns:**
- `table|nil`: Run results or nil on error
- `string|nil`: Error message if failed

#### `submit(code, lang)`

Submit solution.

**Parameters:**
- `code` (string): Solution code
- `lang` (string): Programming language

**Returns:**
- `table|nil`: Submission result or nil on error
- `string|nil`: Error message if failed

### Logger Module (leetgpu.logger)

#### `debug(msg, ...)`

Log debug message (only when debug mode enabled).

**Parameters:**
- `msg` (string): Message to log
- `...`: Additional arguments

#### `info(msg, ...)`

Log info message.

**Parameters:**
- `msg` (string): Message to log
- `...`: Additional arguments

#### `warn(msg, ...)`

Log warning message.

**Parameters:**
- `msg` (string): Message to log
- `...`: Additional arguments

#### `error(msg, ...)`

Log error message.

**Parameters:**
- `msg` (string): Message to log
- `...`: Additional arguments

### Utils Module (leetgpu.utils)

#### `get_lang(slug)`

Get language information by slug.

**Parameters:**
- `slug` (string): Language slug (e.g., "cuda", "cpp")

**Returns:**
- `lg.Lang|nil`: Language info or nil if not found

#### `exec_hooks(event, ...)`

Execute hooks for an event.

**Parameters:**
- `event` (string): Event name
- `...`: Arguments to pass to hooks

## Type Definitions

### lg.ui.Challenge

```lua
{
    id = "string",           -- Challenge ID
    title = "string",        -- Challenge title
    difficulty = "string",   -- Difficulty level (easy, medium, hard)
    description = "string",  -- Challenge description
    slug = "string",         -- URL slug
}
```

### lg.Lang

```lua
{
    id = number,    -- Language ID
    slug = "string", -- Language slug
    name = "string", -- Display name
}
```

### lg.UserConfig

See [configuration.md](configuration.md) for detailed configuration options.

## Events and Hooks

### Available Events

- `enter` - Fired when entering LeetGPU
- `challenge_enter` - Fired when opening a challenge
- `leave` - Fired when exiting LeetGPU

### Using Hooks

```lua
require('leetgpu').setup({
    hooks = {
        ["enter"] = {
            function()
                -- Your code here
            end,
        },
    },
})
```

## Advanced Usage

### Custom API Client

You can extend the API client for additional endpoints:

```lua
local api = require('leetgpu.api.utils')

-- Make custom request
local result, err = api.request("GET", "https://leetgpu.com/custom/endpoint", {
    ["Content-Type"] = "application/json",
})
```

### Custom Caching

Implement custom caching strategies:

```lua
local cache = require('leetgpu.cache')

-- Cache challenge list
cache.write("challenges", { ... })

-- Read cached challenges
local challenges = cache.read("challenges")
```

## Integration Examples

### With Telescope

```lua
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")

-- Custom challenge picker
local function pick_challenge()
    local challenges = require('leetgpu.api.challenges').list()
    
    pickers.new({}, {
        prompt_title = "LeetGPU Challenges",
        finder = finders.new_table {
            results = challenges,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.title,
                    ordinal = entry.title,
                }
            end,
        },
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                -- Open selected challenge
            end)
            return true
        end,
    }):find()
end
```

## Contributing

When contributing to LeetGPU.nvim, please:

1. Follow the existing code structure
2. Add type annotations for Lua LSP
3. Update documentation for new features
4. Write clear commit messages

For more details, see the main README.
