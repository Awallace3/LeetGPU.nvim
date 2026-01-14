local template = require("leetgpu.config.template")
local P = require("plenary.path")

_Lg_state = {
    menu = nil, ---@type lg.ui.Menu
    challenges = {}, ---@type lg.ui.Challenge[]
}

local lazy_plugs = {}

---@class lg.Config
local config = {
    default = template,
    user = template,

    name = "leetgpu.nvim",
    domain = "leetgpu.com",
    debug = false,
    lang = "cuda",
    version = "1.0.0",
    storage = {}, ---@type table<string, Path>
    theme = {}, ---@type lg.highlights
    plugins = {},

    langs = require("leetgpu.config.langs"),
    icons = require("leetgpu.config.icons"),
    sessions = require("leetgpu.config.sessions"),
    stats = require("leetgpu.config.stats"),
    imports = require("leetgpu.config.imports"),
    hooks = require("leetgpu.config.hooks"),

    ---@type lg.UserStatus
    auth = {}, ---@diagnostic disable-line
}

---Merge configurations into default configurations and set it as user configurations.
---
---@param cfg lg.UserConfig Configurations to be merged.
function config.apply(cfg)
    config.user = vim.tbl_deep_extend("force", config.default, cfg or {})
    config.load_plugins()
end

function config.setup()
    config.validate()

    config.user.storage = vim.tbl_map(vim.fn.expand, config.user.storage)

    config.debug = config.user.debug or false ---@diagnostic disable-line
    config.lang = config.user.lang

    config.storage.home = P:new(config.user.storage.home) ---@diagnostic disable-line
    config.storage.home:mkdir()

    config.storage.cache = P:new(config.user.storage.cache) ---@diagnostic disable-line
    config.storage.cache:mkdir()

    for _, plug_load_fn in ipairs(lazy_plugs) do
        plug_load_fn()
    end
end

function config.validate()
    local utils = require("leetgpu.utils")

    assert(vim.fn.has("nvim-0.9.0") == 1, "Neovim >= 0.9.0 required")

    if not utils.get_lang(config.lang) then
        ---@type lg.lang[]
        local lang_slugs = vim.tbl_map(function(lang)
            return lang.slug
        end, config.langs)

        local matches = {}
        for _, slug in ipairs(lang_slugs) do
            local percent = slug:match(config.lang) or config.lang:match(slug)
            if percent then
                table.insert(matches, slug)
            end
        end

        if not vim.tbl_isempty(matches) then
            local log = require("leetgpu.logger")
            log.warn("Did you mean: { " .. table.concat(matches, ", ") .. " }?")
        end

        error("Unsupported Language: " .. config.lang)
    end
end

function config.load_plugins()
    config.plugins = {}
    local plugins = {}

    for plugin, enabled in pairs(config.user.plugins) do
        if enabled then
            table.insert(plugins, plugin)
        end
    end

    for _, plugin in ipairs(plugins) do
        local ok, plug = pcall(require, "leetgpu-plugins." .. plugin)

        if ok then
            if not (plug.opts or {}).lazy then
                plug.load()
            else
                table.insert(lazy_plugs, plug.load)
            end
            config.plugins[plugin] = true
        else
            table.insert(lazy_plugs, function()
                local log = require("leetgpu.logger")
                log.error(plug)
            end)
        end
    end
end

return config
