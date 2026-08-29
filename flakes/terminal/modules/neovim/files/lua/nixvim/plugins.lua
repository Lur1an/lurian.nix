local M = {}
local features = vim.g.lurian_features or {}

function M.lua_runtime_library() return vim.api.nvim_get_runtime_file("", true) end
function M.setup_indent_blankline()
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
end
M.devicons = features.nvchad and require("nvchad.icons.devicons") or {}
function M.nvim_tree_settings()
    local defaults = features.nvchad and require("nvchad.configs.nvimtree") or {}
    return vim.tbl_deep_extend("force", defaults, { filters = { dotfiles = false }, git = { enable = true } })
end
function M.gitsigns_settings()
    return features.nvchad and require("nvchad.configs.gitsigns") or {}
end
function M.telescope_trouble_open(...) return require("trouble.sources.telescope").open(...) end
function M.telescope_close(...) return require("telescope.actions").close(...) end
function M.telescope_settings()
    local settings = vim.deepcopy(features.nvchad and require("nvchad.configs.telescope") or {})
    settings.defaults = settings.defaults or {}
    settings.defaults.mappings = settings.defaults.mappings or { i = {}, n = {} }
    settings.defaults.mappings.i = settings.defaults.mappings.i or {}
    settings.defaults.mappings.n = settings.defaults.mappings.n or {}
    if features.trouble then
        settings.defaults.mappings.i["<c-t>"] = M.telescope_trouble_open
        settings.defaults.mappings.n["<c-t>"] = M.telescope_trouble_open
    end
    settings.defaults.mappings.n.q = M.telescope_close
    return settings
end
function M.cmp_settings()
    local settings = vim.deepcopy(features.nvchad and require("nvchad.configs.cmp") or {})
    settings.mapping = settings.mapping or {}
    settings.mapping["<S-Tab>"] = nil
    settings.sources = {}
    local source_flags = { nvim_lsp = "cmp_nvim_lsp", luasnip = "luasnip", buffer = "cmp_buffer", nvim_lua = "cmp_nvim_lua", async_path = "cmp_async_path" }
    for name, flag in pairs(source_flags) do
        if features[flag] ~= false then table.insert(settings.sources, { name = name }) end
    end
    if features.opencode then table.insert(settings.sources, { name = "opencode", filetype = "opencode_ask" }) end
    return settings
end
function M.setup_luasnip() if features.nvchad then require("nvchad.configs.luasnip") end end
function M.setup_telescope_extensions()
    local telescope = require("telescope")
    if features.nvchad then telescope.load_extension("themes"); telescope.load_extension("terms") end
end
function M.neocord_workspace_text() return "I'd rather play games but idk how to exit this" end
function M.python_dap_adapter(cb, config)
    if config.request == "attach" then
        cb({ type = "server", port = assert((config.connect or config).port, "`connect.port` is required"), host = (config.connect or config).host or "127.0.0.1", options = { source_filetype = "python" } })
        return
    end
    cb({ type = "executable", command = vim.g.nixvim_debugpy_python, args = { "-m", "debugpy.adapter" }, options = { justMyCode = true, source_filetype = "python" } })
end
function M.opencode_start()
    if features.snacks then require("snacks.terminal").open("opencode --port", { win = { position = "right", enter = false } }) end
end
function M.opencode_git_context()
    local handle = io.popen("git diff --cached")
    if not handle then return nil end
    local result = handle:read("*a"); handle:close()
    return result ~= "" and result or nil
end
function M.conform_format_on_save(bufnr)
    if vim.bo[bufnr].filetype ~= "python" and vim.bo[bufnr].filetype ~= "rust" then return nil end
    return { timeout_ms = 3000, lsp_format = "fallback" }
end
function M.rustacean_neotest() return require("rustaceanvim.neotest") end
function M.setup_cmp_autopairs()
    if not (features.cmp and features.autopairs) then return end
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
return M
