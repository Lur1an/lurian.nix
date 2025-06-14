vim.cmd([[autocmd BufWritePre * lua require("conform").format()]])
