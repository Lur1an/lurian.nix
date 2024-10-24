local M = {}

local transparent = true

M.base46 = {
	theme = "chadracula",
	transparency = transparent,
	integrations = { "dap", "trouble" },
}

M.ui = {
	theme_toggle = { "chadracula", "one_light" },
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
