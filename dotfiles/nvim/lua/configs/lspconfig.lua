local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

local servers = {
	"docker_compose_language_service",
	"dockerls",
	"graphql",
	"tailwindcss",
	"svelte",
	"vacuum",
	"html",
	"cssls",
	"tsserver",
	"pyright",
	"marksman",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.nixd.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.helm_ls.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = capabilities,
})

local pylance_dir = vim.env.PYLANCE_PATH
-- lspconfig.pylance.setup({
-- 	cmd = {
-- 		"node",
-- 		vim.fn.expand(pylance_dir .. "/share/vscode/extensions/MS-python.vscode-pylance/dist/server.bundle.js"),
-- 		"--stdio",
-- 	},
-- 	filetypes = { "python" },
-- 	root_dir = function(fname)
-- 		return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
-- 	end,
-- 	settings = {
-- 		python = {
-- 			analysis = {
-- 				typeCheckingMode = "basic",
-- 				diagnosticMode = "openFilesOnly",
-- 				stubPath = "./typings",
-- 				autoSearchPaths = true,
-- 				useLibraryCodeForTypes = true,
-- 				diagnosticSeverityOverrides = {},
-- 				inlayHints = {
-- 					variableTypes = true,
-- 					functionReturnTypes = true,
-- 					callArgumentNames = true,
-- 				},
-- 			},
-- 		},
-- 	},
-- 	-- before_init = function(_, config)
-- 	-- 	-- Adjust the `pythonPath` based on your environment
-- 	-- 	config.settings.python.pythonPath = "/path/to/python"
-- 	-- end,
-- })
