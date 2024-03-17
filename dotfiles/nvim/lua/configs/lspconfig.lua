local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

local servers = {
	"tailwindcss",
	"svelte",
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
lspconfig.nixd.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
}

-- lspconfig.nil_ls.setup({
-- 	autostart = true,
-- 	capabilities = capabilities,
-- 	cmd = { "nil" },
-- 	settings = {
-- 		["nil"] = {
-- 			testSetting = 42,
-- 			formatting = {
-- 				command = { "nixpkgs-fmt" },
-- 			},
-- 		},
-- 	},
-- })
