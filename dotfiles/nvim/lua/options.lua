require "nvchad.options"

-- add yours here!
--
local opt = vim.opt

opt.incsearch = true
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true
opt.foldlevelstart = 5
opt.expandtab = true
opt.smartindent = true
opt.relativenumber = true

vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = "helm",
  },
})

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
