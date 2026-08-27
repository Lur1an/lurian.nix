local M = {}

function M.pre()
	vim.g.mapleader = " "

	local path = vim.env.PATH
	require("nvchad.options")
	vim.env.PATH = path

	require("nvchad.mappings")
	pcall(vim.keymap.del, "n", "<leader>h")
	pcall(vim.keymap.del, "n", "<leader>v")
end

function M.post()
	require("nvchad.autocmds")
	pcall(vim.api.nvim_del_user_command, "TSInstallAll")
end

return M
