local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

-- List of language servers to configure
local servers = {
	"docker_compose_language_service",
	"dockerls",
	"tailwindcss",
	"svelte",
	"terraformls",
	"ansiblels",
	"graphql",
	"ts_ls",
	"just",
	"ruff",
	"nixd",
	"helm_ls",
	"marksman",
}

-- Configure all servers with default settings
for _, lsp in ipairs(servers) do
	vim.lsp.config(lsp, {
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
	vim.lsp.enable(lsp)
end

-- Python LSP configuration with environment variable support
local python_lsp = os.getenv("PYTHON_LSP") or "basedpyright"

if python_lsp == "pyright" then
	vim.lsp.config("pyright", {
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
	vim.lsp.enable("pyright")
else
	vim.lsp.config("basedpyright", {
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			basedpyright = {
				analysis = {
					diagnosticMode = "workspace",
					extraPaths = {
						"./.devenv/state/venv/lib/python3.12/site-packages",
					},
					typeCheckingMode = "basic",
				},
			},
		},
	})
	vim.lsp.enable("basedpyright")
end
