local options = {
	lsp_fallback = true,
	yamlfix = {
		env = {
			YAMLFIX_SEQUENCE_STYLE = "block_style",
			YAMLFIX_EXPLICIT_START = "false",
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		rust = { "rustfmt", lsp_format = "first" },
		typescript = { "prettier" },
		svelte = { "prettier" },
		html = { "prettier" },
    css = { "prettier" },
		yaml = { "prettier" },
		json = { "prettier" },
		javascript = { "prettier" },
	},
}

require("conform").setup(options)
