local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
    rust = { "rustfmt" },
		typescript = { "prettier" },
		svelte = { "prettier" },
		html = { "prettier" },
		yaml = { "prettier" },
		json = { "prettier" },
		javascript = { "prettier" },
	},
}

require("conform").setup(options)
