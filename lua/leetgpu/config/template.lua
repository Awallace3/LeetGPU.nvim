---@alias lg.lang
---| "cpp"
---| "cuda"
---| "python"
---| "python3"
---| "c"

---@alias lg.hook
---| "enter"
---| "challenge_enter"
---| "leave"

---@alias lg.size
---| string
---| number
---| { width: string | number, height: string | number }

---@alias lg.position "top" | "right" | "bottom" | "left"

---@alias lg.direction "col" | "row"

---@alias lg.inject { gap?: number, imports?: (fun(default_imports: string[]): string[])|string|string[], before?: string|string[], after?: string|string[] }

---@alias lg.storage table<"cache"|"home", string>

---@alias lg.picker { provider?: "fzf-lua" | "telescope" | "snacks-picker" }

---@class lg.UserConfig
local M = {
    ---@type string
    arg = "leetgpu.nvim",

    ---@type lg.lang
    lang = "cuda",

    ---@type lg.storage
    storage = {
        home = vim.fn.stdpath("data") .. "/leetgpu",
        cache = vim.fn.stdpath("cache") .. "/leetgpu",
    },

    ---@type table<string, boolean>
    plugins = {
        non_standalone = false,
    },

    ---@type boolean
    logging = true,

    injector = {}, ---@type table<lg.lang, lg.inject>

    cache = {
        update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
    },

    editor = {
        reset_previous_code = true, ---@type boolean
        fold_imports = true, ---@type boolean
    },

    console = {
        open_on_runcode = true, ---@type boolean

        dir = "row", ---@type lg.direction

        size = { ---@type lg.size
            width = "90%",
            height = "75%",
        },

        result = {
            size = "60%", ---@type lg.size
        },

        testcase = {
            virt_text = true, ---@type boolean

            size = "40%", ---@type lg.size
        },
    },

    description = {
        position = "left", ---@type lg.position

        width = "40%", ---@type lg.size

        show_stats = true, ---@type boolean
    },

    ---@type lg.picker
    picker = { provider = nil },

    hooks = {
        ---@type fun()[]
        ["enter"] = {},

        ---@type fun(challenge: lg.ui.Challenge)[]
        ["challenge_enter"] = {},

        ---@type fun()[]
        ["leave"] = {},
    },

    keys = {
        toggle = { "q" }, ---@type string|string[]
        confirm = { "<CR>" }, ---@type string|string[]

        reset_testcases = "r", ---@type string
        use_testcase = "U", ---@type string
        focus_testcases = "H", ---@type string
        focus_result = "L", ---@type string
    },

    ---@type lg.highlights
    theme = {},

    ---@type boolean
    image_support = false,

    ---@type table CLI settings
    cli = {
        mode = "functional", ---@type "functional" | "cycle-accurate"
        gpu = nil, ---@type string|nil GPU name (e.g., "NVIDIA GV100")
    },
}

return M
