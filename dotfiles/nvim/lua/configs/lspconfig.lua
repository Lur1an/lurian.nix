local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

local servers = {
	"docker_compose_language_service",
	"dockerls",
	"tailwindcss",
	"helm_ls",
	"svelte",
	"vacuum",
	"html",
	"cssls",
	"tsserver",
	"pyright",
	"marksman",
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.gotmpl = {
	install_info = {
		url = "https://github.com/ngalaiko/tree-sitter-go-template",
		files = { "src/parser.c" },
	},
	filetype = "gotmpl",
	used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
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
