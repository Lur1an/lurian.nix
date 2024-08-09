local M = {}

local transparent = false

M.ui = {
	theme = "catppuccin",
	theme_toggle = { "catppuccin", "one_light" },
	transparency = transparent,
	nvdash = {
		load_on_startup = false,
		header = {},
	},
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

return M
