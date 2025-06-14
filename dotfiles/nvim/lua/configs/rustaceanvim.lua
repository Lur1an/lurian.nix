local extension_path = vim.env.HOME .. "/.vscode-lldb/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

vim.g.rustaceanvim = {
	-- Plugin configuration
	tools = {},
	-- LSP configuration
	server = {
		on_init = require("nvchad.configs.lspconfig").on_init,
		capabilities = require("nvchad.configs.lspconfig").capabilities,
		on_attach = function(client, bufnr)
			local map = vim.keymap.set
			-- map("n", "<leader>ca", function()
			--   vim.cmd.RustLsp("codeAction")
			-- end)
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
		end,
		default_settings = {
			-- rust-analyzer language server configuration
			["rust-analyzer"] = {
				assist = {
					importGranularity = "module",
					importPrefix = "by_self",
				},
				rustfmt = {
					extraArgs = { "+nightly" },
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
