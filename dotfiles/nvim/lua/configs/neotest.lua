require("neotest").setup({
	adapters = {
		require("neotest-python")({
			-- TODO DOESN'T WORK RN
			dap = { justMyCode = true },
		}),
		require("rustaceanvim.neotest"),
	},
})
