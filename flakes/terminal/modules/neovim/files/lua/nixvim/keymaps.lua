local M = {}

M.jump_to_next_diagnostic = function()
	vim.diagnostic.goto_next({ float = { border = "rounded" } })
end

M.jump_to_previous_diagnostic = function()
	vim.diagnostic.goto_prev({ float = { border = "rounded" } })
end

M.file_format_with_conform = function()
	require("conform").format()
end

M.dap_run_last_test = function()
	require("dap").run_last()
end

M.dap_conditional_breakpoint = function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end

M.dap_toggle_ui = function()
	require("dapui").toggle()
end

M.dap_toggle_breakpoint = function()
	require("dap").toggle_breakpoint()
end

M.dap_debug_test = function()
	local debug_test = {
		rust = function()
			vim.cmd("RustLsp debuggables")
		end,
		python = function()
			require("dap-python").test_method()
		end,
	}
	debug_test[vim.bo.filetype]()
end

M.dap_step_over = function()
	require("dap").step_over()
end

M.dap_continue = function()
	require("dap").continue()
end

M.dap_restart = function()
	require("dap").restart()
end

M.dap_restart_2 = function()
	require("dap").restart()
end

M.dap_terminate = function()
	require("dap").terminate()
end

M.dap_evaluate_selection = function()
	require("dapui").eval()
end

M.neotest_run_nearest_test = function()
	require("neotest").run.run()
end

M.neotest_debug_nearest_test = function()
	require("neotest").run.run({ strategy = "dap" })
end

M.general_close_buffer = function()
	require("nvchad.tabufline").close_buffer()
end

M.toggle_k9s = function()
	require("snacks").terminal.toggle("k9s", {
		win = {
			position = "right",
			width = 0.4,
		},
	})
end

M.harpoon_toggle_quick_menu = function()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list(), { ui_max_width = 80 })
end

M.harpoon_add_file = function()
	require("harpoon"):list():add()
end

M.harpoon_nav_file_1 = function()
	require("harpoon"):list():select(1)
end

M.harpoon_nav_file_2 = function()
	require("harpoon"):list():select(2)
end

M.harpoon_nav_file_3 = function()
	require("harpoon"):list():select(3)
end

M.harpoon_navigate_next = function()
	require("harpoon"):list():next({ ui_nav_wrap = true })
end

M.harpoon_navigate_previous = function()
	require("harpoon"):list():prev({ ui_nav_wrap = true })
end

M.nvimtree_focus_open_nvimtree_closes_if_open = function()
	local api = require("nvim-tree.api")
	if api.tree.is_visible() then
		api.tree.close()
	else
		api.tree.focus()
	end
end

M.zenmode_toggle = function()
	require("zen-mode").toggle()
end

M.source_themes = function()
	require("nixvim.theme").reload()
end

M.toggle_trasparency = function()
	require("base46").toggle_transparency()
end

M.code_action = function()
	vim.lsp.buf.code_action()
end

M.diagnostic_float = function()
	vim.diagnostic.open_float()
end

M.references = function()
	vim.lsp.buf.references()
end

M.definition = function()
	vim.lsp.buf.definition()
end

M.implementation = function()
	vim.lsp.buf.implementation()
end

M.type_definition = function()
	vim.lsp.buf.type_definition()
end

M.trouble_errors = function()
	vim.diagnostic.setqflist({ open = false, severity = vim.diagnostic.severity.ERROR })
	if #vim.fn.getqflist() == 1 then
		vim.cmd("cfirst")
	end
	vim.cmd("Trouble diagnostics toggle focus=false win.position=bottom filter.severity=vim.diagnostic.severity.ERROR")
end

M.trouble_diagnostics = function()
	vim.diagnostic.setqflist({ open = false, severity = vim.diagnostic.severity.WARN })
	if #vim.fn.getqflist() == 1 then
		vim.cmd("cfirst")
	end
	vim.cmd("Trouble diagnostics toggle focus=false win.position=bottom")
end

M.review_changes_diffview_toggle = function()
	local view = require("diffview.lib").get_current_view()
	if view then
		vim.cmd("DiffviewClose")
	else
		vim.api.nvim_feedkeys(":DiffviewOpen ", "n", false)
	end
end

M.toggle_opencode = function()
	require("snacks.terminal").toggle("opencode --port", {
		win = {
			position = "right",
			enter = true,
		},
	})
end

M.ask_opencode = function()
	require("opencode").ask("@this: ")
end

return M
