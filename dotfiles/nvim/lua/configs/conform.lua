local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		typescript = { "prettier" },
		svelte = { "prettier" },
		yaml = { "prettier" },
		json = { "prettier" },
		javascript = { "prettier" },
	},
}

require("conform").setup(options)
