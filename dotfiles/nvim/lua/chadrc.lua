local M = {}

local transparent = false

M.base46 = {
	theme = "auto",
	transparency = transparent,
	integrations = { "dap", "trouble" },
}

M.ui = {
	theme_toggle = { "auto", "one_light" },
	term = {
		size = 10,
	},
	telescope = {
		style = "bordered", -- borderless / bordered
	},
	tabufline = {
		enabled = true,
	},
}

M.nvdash = {
  load_on_startup = true,
}

return M
