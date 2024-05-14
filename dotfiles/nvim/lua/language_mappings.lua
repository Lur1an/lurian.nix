local M = {}

M.debug_test = {
	rust = function()
		vim.cmd("RustLsp debuggables")
	end,
	python = function()
		require("dap-python").test_method()
	end,
}

return M
