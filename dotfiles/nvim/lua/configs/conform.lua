local options = {
	lsp_fallback = true,
	yamlfix = {
		env = {
			YAMLFIX_SEQUENCE_STYLE = "block_style",
			YAMLFIX_EXPLICIT_START = "false",
			YAMLFIX_WHITELINES = "1",
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		-- rust = { "rustfmt", lsp_format = "first" },
		rust = { "rustfmt" },
		typescript = { "prettier" },
		svelte = { "prettier" },
		html = { "prettier" },
		graphql = { "prettier" },
		css = { "prettier" },
		yaml = { "prettier" },
		json = { "prettier" },
		javascript = { "prettier" },
	},
}

require("conform").setup(options)
