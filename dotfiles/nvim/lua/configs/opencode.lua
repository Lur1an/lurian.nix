local M = {}

require("opencode").setup({
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

-- Auto-focus opencode terminal when it's created
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*opencode*",
	callback = function(ev)
		-- Focus the terminal window
		local win = vim.fn.bufwinid(ev.buf)
		if win ~= -1 then
			vim.api.nvim_set_current_win(win)
			vim.cmd("startinsert")
		end
	end,
})

-- Also handle BufEnter for when switching to opencode buffer
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	callback = function(ev)
-- 		local buf_name = vim.api.nvim_buf_get_name(ev.buf)
-- 		if vim.bo[ev.buf].buftype == "terminal" and 
-- 		   (buf_name:match("opencode") or buf_name:match("term://.*opencode")) then
-- 			-- Automatically enter insert mode in opencode terminal
-- 			vim.defer_fn(function()
-- 				if vim.api.nvim_get_current_buf() == ev.buf then
-- 					vim.cmd("startinsert")
-- 				end
-- 			end, 10)
-- 		end
-- 	end,
-- })

return M

