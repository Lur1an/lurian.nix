local M = {}

local transparent = true

M.ui = {
	theme = "catppuccin",
	theme_toggle = { "catppuccin", "one_light" },
	transparency = transparent,
	nvdash = {
		load_on_startup = false,
		header = {},
	},
	telescope = {
		style = "bordered", -- borderless / bordered
	},
	tabufline = {
		enabled = true,
	},
}

return M
