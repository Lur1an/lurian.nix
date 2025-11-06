require("neotest").setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = true },
		}),
		require("rustaceanvim.neotest"),
	},
})
