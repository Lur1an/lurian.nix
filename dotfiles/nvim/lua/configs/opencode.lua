local M = {}

require("opencode").setup({
	-- Terminal configuration
	terminal = {
		position = "float", -- or "bottom", "right"
		size = 0.8, -- 80% of screen for float, or number of lines/columns for split
	},

	-- Custom prompts
	prompts = {
		explain = {
			key = "<leader>oe",
			description = "Explain the selected code",
		},
		refactor = {
			description = "Refactor this code for better readability",
			prompt = "Please refactor the following code to improve readability and maintainability: @selection",
			key = "<leader>or",
		},
		test = {
			description = "Write tests for this code",
			prompt = "Write comprehensive tests for the following code: @selection",
		},
		fix = {
			description = "Fix issues in this code",
			prompt = "Please fix any issues in the following code: @diagnostics",
		},
	},

	-- Custom contexts
	contexts = {
		["@git"] = {
			description = "Git diff of current changes",
			value = function()
				local handle = io.popen("git diff --cached")
				if handle then
					local result = handle:read("*a")
					handle:close()
					return result ~= "" and result or nil
				end
				return nil
			end,
		},
	},

	-- Auto-reload buffers when opencode modifies them
	auto_reload = true,

	-- Show notifications for opencode events
	notifications = {
		enabled = true,
		level = vim.log.levels.INFO,
	},
})

return M

