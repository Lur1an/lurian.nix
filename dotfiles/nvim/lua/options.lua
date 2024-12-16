require "nvchad.options"

-- add yours here!
--
local opt = vim.opt

local in_tmux = os.getenv("TMUX") ~= nil

if in_tmux then
  opt.laststatus = 0
end

opt.incsearch = true
opt.foldmethod = "expr"
opt.laststatus = 3
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true
opt.foldlevelstart = 5
opt.expandtab = true
opt.smartindent = true
opt.relativenumber = true

vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = "helm",
    [".*/templates/.*%.tpl"] = "helm",
    [".*/.kube/config"] = "yaml",
    [".*/kubeconfig"] = "yaml",
  },
})

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
