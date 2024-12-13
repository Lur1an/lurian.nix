local M = {}

local transparent = true

M.base46 = {
	theme = "catppuccin",
	transparency = transparent,
	integrations = { "dap", "trouble" },
}

M.ui = {
	theme_toggle = { "catppuccin", "catppuccin" },
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
  load_on_startup = false,
}

return M
