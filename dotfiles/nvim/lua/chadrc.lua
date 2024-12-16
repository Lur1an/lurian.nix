local M = {}

local transparent = true

local in_tmux = os.getenv("TMUX") ~= nil

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
  statusline = {
    enabled = not in_tmux,
  },
	telescope = {
		style = "bordered", -- borderless / bordered
	},
	tabufline = {
		enabled = true,
    order = { "treeOffset", "buffers" },
	},
}

M.nvdash = {
  load_on_startup = false,
}

return M
