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
	"html",
	"cssls",
	"tsserver",
	"pyright",
	-- "basedpyright",
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
