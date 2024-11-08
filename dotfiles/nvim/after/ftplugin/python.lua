---@diagnostic disable
-- vim.cmd([[autocmd BufWritePre * lua require("conform").format()]])
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.py",
	callback = function()
		require("conform").format()
		vim.lsp.buf.code_action({
			context = {
				only = { "source.fixAll.ruff" },
			},
			apply = true,
		})
	end,
})
