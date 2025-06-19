local M = {}

local transparent = true

local in_tmux = os.getenv("TMUX") ~= nil

M.base46 = {
	theme = "gruvbox_light",
	transparency = transparent,
	integrations = { "dap", "trouble" },
}

M.term = {
	sizes = {
		sp = 0.2,
		vsp = 0.3,
	},
	float = {
		relative = "editor",
		row = 0.25,
		col = 0.2,
		width = 0.6,
		height = 0.5,
		border = "single",
	},
}

M.ui = {
	theme_toggle = { "gruvbox_light", "gruvbox_light" },
	telescope = {
		style = "bordered", -- borderless / bordered
	},
	statusline = { enabled = not in_tmux },
	tabufline = {
		enabled = true,
		order = { "treeOffset", "buffers" },
	},
}

M.nvdash = {
	load_on_startup = false,
}

return M
