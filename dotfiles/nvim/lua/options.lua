require("nvchad.options")
require("custom")

-- add yours here!
--
local opt = vim.opt

local in_tmux = os.getenv("TMUX") ~= nil

if in_tmux then
	vim.opt.laststatus = 0
	vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
	vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
  vim.cmd "set statusline=%{repeat('─',winwidth('.'))}"
else
	vim.o.laststatus = 3
end

opt.incsearch = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = true
opt.foldlevelstart = 99
opt.expandtab = true
opt.smartindent = true
opt.relativenumber = true

vim.filetype.add({
	pattern = {
    [".*gel"] = "edgeql",
		[".*/templates/.*%.yaml"] = "helm",
		[".*/templates/.*%.tpl"] = "helm",
		[".*/.kube/config"] = "yaml",
		[".*/kubeconfig"] = "yaml",
	},
})

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
