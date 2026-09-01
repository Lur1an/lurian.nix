local M = {}

local function rename_action()
	return require("nvchad.lsp.renamer")
end

function M.lsp_on_attach(_, bufnr)
	local function map(key, action, desc)
		vim.keymap.set("n", key, action, { buffer = bufnr, desc = desc })
	end
	map("gD", vim.lsp.buf.declaration, "LSP go to declaration")
	map("<leader>ra", rename_action(), "LSP rename")
	map("<leader>ls", vim.lsp.buf.signature_help, "LSP signature help")
	map("<leader>wa", vim.lsp.buf.add_workspace_folder, "LSP add workspace folder")
	map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "LSP remove workspace folder")
	map("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "LSP list workspace folders")
end

function M.rust_on_attach(_, bufnr)
	local function map(key, action, desc)
		vim.keymap.set("n", key, action, { buffer = bufnr, desc = desc })
	end
	map("K", vim.lsp.buf.hover, "LSP hover")
	map("gd", vim.lsp.buf.declaration, "LSP go to declaration")
	map("gi", vim.lsp.buf.implementation, "LSP go to implementation")
	map("<leader>D", vim.lsp.buf.type_definition, "LSP go to type definition")
	map("<leader>ra", rename_action(), "LSP rename")
	map("<leader>ca", vim.lsp.buf.code_action, "LSP code action")
	map("gr", vim.lsp.buf.references, "LSP references")
end

function M.rust_dap_adapter()
	return require("rustaceanvim.config").get_codelldb_adapter(
		vim.env.HOME .. "/.vscode-lldb/adapter/codelldb",
		vim.env.HOME .. "/.vscode-lldb/lldb/lib/liblldb.so"
	)
end

function M.pre()
	vim.g.mapleader = " "
	require("nixvim.nvchad").pre()
	vim.treesitter.language.register("markdown", "mdx")
end

function M.post()
	require("nixvim.nvchad").post()
	if os.getenv("TMUX") ~= nil then
		vim.o.laststatus = 0
		vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
		vim.o.statusline = "%{repeat('─',winwidth('.'))}"
	else
		vim.o.laststatus = 3
	end

	local dap, dapui = require("dap"), require("dapui")
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	local group = vim.api.nvim_create_augroup("NixvimOpenCode", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "OpencodeEvent:tui.command.execute",
		callback = function(args)
			local event = args.data and args.data.event
			if event and event.properties and event.properties.command == "prompt.submit" then
				local win = require("snacks.terminal").get("opencode --port", { create = false })
				if win then
					win:show()
				end
			end
		end,
	})

	require("configs.verus-treesitter").setup()
end

return M
