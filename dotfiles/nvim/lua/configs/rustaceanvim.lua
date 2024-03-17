local extension_path = vim.env.HOME .. "/.vscode-lldb/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

vim.g.rustaceanvim = {
	-- Plugin configuration
	tools = {},
	-- LSP configuration
	server = {
		on_attach = function(client, bufnr)
			-- I hate my fucking life why o god why is this a thing with this plugin, I cba refactoring LSP actions, so here is a nice fkin copy and paste.
			local map = vim.keymap.set
			map("n", "<leader>ca", function()
				vim.cmd.RustLsp("codeAction")
			end)
			map("n", "K", function()
				vim.lsp.buf.hover()
			end)

			map("n", "gd", function()
				vim.lsp.buf.declaration()
			end)

			map("n", "gi", function()
				vim.lsp.buf.implementation()
			end)

			map("n", "<leader>D", function()
				vim.lsp.buf.type_definition()
			end)

			map("n", "<leader>ra", function()
				require("nvchad.lsp.renamer")()
			end)

			map("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end)

			map("n", "gr", function()
				vim.lsp.buf.references()
			end)

			map("n", "<leader>f", function()
				vim.cmd.RustLsp("explainError")
			end)

			map("n", "<leader>mc", function()
				vim.cmd.RustLsp("expandMacro")
			end)

			map("n", "[d", function()
				vim.diagnostic.goto_prev({ float = { border = "rounded" } })
			end)

			map("n", "]d", function()
				vim.diagnostic.goto_next({ float = { border = "rounded" } })
			end)

			map("n", "<leader>q", function()
				vim.diagnostic.setloclist()
			end)
		end,
		default_settings = {
			-- rust-analyzer language server configuration
			["rust-analyzer"] = {
				assist = {
					importGranularity = "module",
					importPrefix = "by_self",
				},
				cargo = {
					buildScripts = {
						enable = true,
					},
					allFeatures = true,
				},
				procMacro = {
					enable = true,
				},
			},
		},
	},
	-- DAP configuration
	dap = {
		adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
}
