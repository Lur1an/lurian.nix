local M = {}

function M.lua_runtime_library()
	return vim.api.nvim_get_runtime_file("", true)
end
function M.setup_indent_blankline()
	local hooks = require("ibl.hooks")
	hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
end
M.devicons = require("nvchad.icons.devicons")
function M.nvim_tree_settings()
	return vim.tbl_deep_extend("force", require("nvchad.configs.nvimtree"), {
		filters = { dotfiles = false },
		git = { enable = true },
	})
end
function M.gitsigns_settings()
	return require("nvchad.configs.gitsigns")
end
function M.telescope_trouble_open(...)
	return require("trouble.sources.telescope").open(...)
end
function M.telescope_close(...)
	return require("telescope.actions").close(...)
end
function M.telescope_settings()
	local settings = vim.deepcopy(require("nvchad.configs.telescope"))
	settings.defaults.mappings.i = settings.defaults.mappings.i or {}
	settings.defaults.mappings.n = settings.defaults.mappings.n or {}
	settings.defaults.mappings.i["<c-t>"] = M.telescope_trouble_open
	settings.defaults.mappings.n["<c-t>"] = M.telescope_trouble_open
	settings.defaults.mappings.n.q = M.telescope_close
	return settings
end
function M.cmp_settings()
	local settings = vim.deepcopy(require("nvchad.configs.cmp"))
	settings.mapping["<S-Tab>"] = nil
	settings.sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "async_path" },
		{ name = "opencode", filetype = "opencode_ask" },
	}
	return settings
end
function M.setup_luasnip()
	require("nvchad.configs.luasnip")
end
function M.setup_telescope_extensions()
	local telescope = require("telescope")
	telescope.load_extension("themes")
	telescope.load_extension("terms")
end
function M.neocord_workspace_text()
	return "I'd rather play games but idk how to exit this"
end
function M.python_dap_adapter(cb, config)
	if config.request == "attach" then
		cb({
			type = "server",
			port = assert((config.connect or config).port, "`connect.port` is required"),
			host = (config.connect or config).host or "127.0.0.1",
			options = { source_filetype = "python" },
		})
		return
	end
	cb({
		type = "executable",
		command = vim.g.nixvim_debugpy_python,
		args = { "-m", "debugpy.adapter" },
		options = { justMyCode = true, source_filetype = "python" },
	})
end
function M.opencode_start()
	require("snacks.terminal").open("opencode --port", { win = { position = "right", enter = false } })
end
function M.opencode_git_context()
	local handle = io.popen("git diff --cached")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	return result ~= "" and result or nil
end
function M.conform_format_on_save(bufnr)
	if vim.bo[bufnr].filetype ~= "python" and vim.bo[bufnr].filetype ~= "rust" then
		return nil
	end
	return { timeout_ms = 3000, lsp_format = "fallback" }
end
function M.rustacean_neotest()
	return require("rustaceanvim.neotest")
end
function M.setup_cmp_autopairs()
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
return M
