local M = {}

-- opencode must be started with --port so it exposes its server.
local opencode_cmd = "opencode --port"

---@type snacks.terminal.Opts
local terminal_opts = {
	win = {
		position = "right",
	},
}

-- Toggle the embedded opencode terminal (focuses it on open).
function M.toggle()
	require("snacks.terminal").toggle(opencode_cmd, vim.tbl_deep_extend("force", terminal_opts, {
		win = { enter = true },
	}))
end

vim.g.opencode_opts = {
	server = {
		-- Auto-start opencode (without stealing focus) when none is running.
		start = function()
			require("snacks.terminal").open(opencode_cmd, vim.tbl_deep_extend("force", terminal_opts, {
				win = { enter = false },
			}))
		end,
	},

	-- Custom context placeholders. Builders receive the context and return a string (or nil).
	contexts = {
		["@git"] = function()
			local handle = io.popen("git diff --cached")
			if not handle then
				return nil
			end
			local result = handle:read("*a")
			handle:close()
			return result ~= "" and result or nil
		end,
	},

	-- Prompts available through `require("opencode").select()`.
	select = {
		prompts = {
			refactor = "Refactor @this to improve readability and maintainability",
		},
	},

	-- Replaces the old `auto_reload` / `notifications` options.
	events = {
		enabled = true,
		reload = true,
	},
}

-- Reveal the opencode terminal whenever a prompt is submitted.
vim.api.nvim_create_autocmd("User", {
	pattern = { "OpencodeEvent:tui.command.execute" },
	callback = function(args)
		local event = args.data and args.data.event
		if event and event.properties and event.properties.command == "prompt.submit" then
			local win = require("snacks.terminal").get(opencode_cmd, { create = false })
			if win then
				win:show()
			end
		end
	end,
})

return M
