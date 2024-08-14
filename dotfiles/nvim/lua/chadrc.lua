local M = {}

local transparent = true

M.ui = {
	theme = "ayu_dark",
	theme_toggle = { "ayu_dark", "one_light" },
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
