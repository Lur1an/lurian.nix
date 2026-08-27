local M = {}

local in_tmux = os.getenv("TMUX") ~= nil

M.base46 = {
	theme = "chadracula-evondev",
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
	telescope = {
		style = "bordered",
	},
	statusline = { enabled = not in_tmux },
	tabufline = {
		enabled = true,
		order = { "treeOffset", "buffers" },
	},
}

M.nvdash = {
	buttons = {
		{ txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
		{ txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
		{ txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
		{ txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
		{ txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
		{ txt = "  Managed by Nixvim", hl = "NvDashFooter", no_gap = true },
		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
	},
}

return M
