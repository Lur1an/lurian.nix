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
  "lua_ls",
	"terraformls",
	"ts_ls",
	"just",
  "basedpyright",
	"ruff",
	"nixd",
	"helm_ls",
	"marksman",
}
vim.diagnostic.config({ virtual_text = true })
vim.lsp.enable(servers)

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
