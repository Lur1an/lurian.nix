local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

local servers = {
	"docker_compose_language_service",
	"dockerls",
	"tailwindcss",
	"svelte",
  "terraformls",
	"ansiblels",
	"graphql",
	"ts_ls",
	"ruff",
	"nixd",
	"helm_ls",
	"marksman",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
-- read PYTHON_LSP env variable to choose between pyright and basedpyright
local python_lsp = os.getenv("PYTHON_LSP") or "basedpyright"

if python_lsp == "pyright" then
	lspconfig.pyright.setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
else
	lspconfig.basedpyright.setup({
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
end
