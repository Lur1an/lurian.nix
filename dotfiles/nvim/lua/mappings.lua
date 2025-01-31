require("nvchad.mappings")

local map = vim.keymap.set
local unmap = vim.keymap.del

-- clear unwanted mappings
unmap("n", "<leader>h")
unmap("n", "<leader>v")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>rl", function()
	vim.cmd("e!")
end, { desc = "reload file" })
map("n", "]d", function()
	vim.diagnostic.goto_next({ float = { border = "rounded" } })
end, { desc = "jump to next diagnostic" })
map("n", "[d", function()
	vim.diagnostic.goto_prev({ float = { border = "rounded" } })
end, { desc = "jump to previous diagnostic" })

map("n", "<leader>fm", function()
	---@diagnostic disable-next-line: different-requires
	require("conform").format()
end, { desc = "File Format with conform" })

-- dadbodui mappings
map("n", "<leader>db", function()
	vim.cmd("DBUIToggle")
end, { desc = "DBUIToggle toggle DBUI" })

-- dap mappings
local dap = require("dap")
local dapui = require("dapui")
map("n", "<Leader>dl", function()
	dap.run_last()
end, { desc = "dap run last test" })
map("n", "<leader>cb", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
map("n", "<C-y>", function()
	dapui.toggle()
end, { desc = "dap toggle UI" })
map("n", "<leader>b", function()
	dap.toggle_breakpoint()
end, { desc = "dap toggle breakpoint" })
map("n", "<F9>", function()
	require("language_mappings").debug_test[vim.bo.filetype]()
end, { desc = "dap debug test" })
map("n", "<F10>", function()
	dap.step_over()
end, { desc = "dap step over" })
map("n", "<F5>", function()
	dap.continue()
end, { desc = "dap continue" })
map("n", "<S-F5>", function()
	dap.restart()
end, { desc = "dap restart" })
map("n", "<F17>", function()
	dap.restart()
end, { desc = "dap restart" })
map("n", "<F8>", function()
	dap.terminate()
end, { desc = "dap terminate" })
map("v", "<C-k>", function()
	dapui.eval()
end, { desc = "dap evaluate selection" })

-- neotest
local neotest = require("neotest")
map("n", "<leader>rt", function()
	neotest.run.run()
end, { desc = "neotest run nearest test" })

map("n", "<leader>dt", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "neotest debug nearest test" })
-- general mappings
map("i", "<C-c>", "<cmd> w <CR><ESC>", { desc = "general save and exit insert mode" })
map("n", "q", function()
	require("nvchad.tabufline").close_buffer()
end, { desc = "general close buffer" })
-- Center the screen after line jumps with 'j' and 'k'
map("n", "j", 'v:count > 1 ? "jzz" : "j"', { expr = true, noremap = true, desc = "numbered jump with centering" })
map("n", "k", 'v:count > 1 ? "kzz" : "k"', { expr = true, noremap = true, desc = "numbered jump with centering" })
map("n", "n", "nzzzv", { desc = "general find next occurrence" })
map("n", "N", "Nzzzv", { desc = "general find previous occurrence" })
map("n", "Q", ":only<CR>", { desc = "close other windows" })
map("n", "<leader>j", ":lnext<CR>zz", { desc = "general location next" })
map("n", "<leader>k", ":lprev<CR>zz", { desc = "general location previous" })
map("n", "<leader>s", "<cmd> w <CR>", { desc = "general save file" })
map("n", "<M-j>", ":cn<CR>zz", { desc = "general quickfix next" })
map("n", "<M-k>", ":cp<CR>zz", { desc = "general quickfix previous" })
map("n", "<C-u>", "<C-u>zz", { desc = "general scroll up" })
map("n", "<C-d>", "<C-d>zz", { desc = "general scroll down" })
map("n", "<leader>d", '"_d', { desc = "general delete into void" })
map("n", "<C-o>", "<C-o>zz", { desc = "general jump back (with line centering)" })
map("n", "<C-i>", "<C-i>zz", { desc = "general jump forward (with line centering)" })
map("v", "K", ":m'<-2<CR>gv=gv", { desc = "general move selection up" })
map("v", "J", ":m'>+1<CR>gv=gv", { desc = "general move selection down" })
map("v", "(", "c()<C-c>P", { desc = "general surround with '()'" })
map("v", "{", "c{}<C-c>P", { desc = "general surround with '{}'" })
map("v", "[", "c[]<C-c>P", { desc = "general surround with '[]'" })
map("v", "'", "c''<C-c>P", { desc = "general surround with single quotes" })
map("v", '"', 'c""<C-c>P', { desc = "general surround with double quotes" })
map("v", "`", "c``<C-c>P", { desc = "general surround with backticks" })
map("v", "<leader>d", '"_d', { desc = "general delete into void" })
map("v", "<leader>p", '"_p', { desc = "general paste and delete previous into void" })

-- harpoon mappings
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")

map("n", "<C-e>", function()
	harpoon_ui.toggle_quick_menu()
end, { desc = "harpoon toggle quick menu" })
map("n", "<leader>a", function()
	harpoon_mark.add_file()
end, { desc = "harpoon add file" })
map("n", "<C-a>", function()
	harpoon_ui.nav_file(1)
end, { desc = "harpoon nav file 1" })
map("n", "<C-s>", function()
	harpoon_ui.nav_file(2)
end, { desc = "harpoon nav file 2" })
map("n", "<C-f>", function()
	harpoon_ui.nav_file(3)
end, { desc = "harpoon nav file 3" })
map("n", "<C-g>", function()
	harpoon_ui.nav_file(4)
end, { desc = "harpoon nav file 4" })
map("n", "<C-n>", function()
	harpoon_ui.nav_next()
end, { desc = "harpoon navigate next" })
map("n", "<C-p>", function()
	harpoon_ui.nav_prev()
end, { desc = "harpoon navigate previous" })

-- nvimtree mappings
map("n", "<leader>e", function()
	local api = require("nvim-tree.api")
	if api.tree.is_visible() then
		api.tree.close()
	else
		api.tree.focus()
	end
end, { desc = "nvimtree focus/open nvimtree (closes if open)" })

-- Zenmode
local zen = require("zen-mode")
map("n", "<leader>zm", function()
	zen.toggle()
end, { desc = "zenmode toggle" })

-- theme related stuff
map("n", "<leader>ct", function()
	require("nvchad.utils").reload("themes")
end, { desc = "source themes" })

map("n", "<leader>tt", function()
	require("base46").toggle_transparency()
end, { desc = "toggle trasparency" })

-- lsp mappings
map("n", "<leader>ll", function()
	vim.cmd("LspRestart")
end, { desc = "restart lsp" })

map("n", "S", function()
	vim.diagnostic.open_float()
end, { desc = "restart lsp" })

-- treesitter
map("n", "<leader>it", function()
	vim.cmd("InspectTree")
end, { desc = "inspect tree" })
map("n", "<leader>ic", function()
	vim.cmd("Inspect")
end, { desc = "inspect cursor" })

-- trouble
map("n", "<leader>te", function()
	vim.diagnostic.setqflist({ open = false, severity = vim.diagnostic.severity.ERROR })
	if #vim.fn.getqflist() == 1 then
		vim.cmd("cfirst")
	end
	vim.cmd("Trouble diagnostics toggle focus=false win.position=bottom filter.severity=vim.diagnostic.severity.ERROR")
end, { desc = "trouble errors" })

map("n", "<leader>td", function()
	vim.cmd("Trouble diagnostics toggle focus=false win.position=bottom")
end, { desc = "Trouble diagnostics" })

map("n", "<leader>ts", function()
	vim.cmd("Trouble symbols toggle focus=false")
end, { desc = "trouble symbols" })

map("n", "<leader>mp", function()
	vim.cmd("MarkdownPreview")
end, { desc = "MarkdownPreview" })
