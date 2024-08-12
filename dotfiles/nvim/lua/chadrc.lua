local M = {}

local transparent = true

M.ui = {
	theme = "bearded-arc",
	theme_toggle = { "bearded-arc", "one_light" },
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
