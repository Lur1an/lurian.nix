require("neotest").setup({
	adapters = {
		require("neotest-python")({
			-- TODO DOESN'T WORK RN
			dap = { justMyCode = false },
		}),
		require("rustaceanvim.neotest"),
	},
})
