local M = {}

function M.setup()
	local group = vim.api.nvim_create_augroup("verus-treesitter", { clear = true })
	local pending = {}

	local function active_language(bufnr)
		local highlighter = vim.treesitter.highlighter.active[bufnr]
		return highlighter and highlighter.tree:lang()
	end

	local schedule_parser
	local function select_parser(bufnr)
		if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "rust" then
			return
		end

		local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, "rust")
		if not parser_ok then
			return
		end

		local query_ok, query = pcall(
			vim.treesitter.query.parse,
			"rust",
			[[
                (macro_invocation
                  macro: [
                    (identifier) @name
                    (scoped_identifier name: (identifier) @name)
                  ])
            ]]
		)
		if not query_ok then
			return
		end

		local tree = parser:parse()[1]
		local language = "rust"

		for _, node in query:iter_captures(tree:root(), bufnr) do
			if vim.treesitter.get_node_text(node, bufnr) == "verus" then
				language = "verus"
				break
			end
		end

		if active_language(bufnr) == language then
			return
		end

		if not pcall(vim.treesitter.get_parser, bufnr, language) then
			return
		end

		vim.treesitter.stop(bufnr)
		if not pcall(vim.treesitter.start, bufnr, language) then
			pcall(vim.treesitter.start, bufnr, "rust")
		end
	end

	schedule_parser = function(bufnr, delay)
		pending[bufnr] = (pending[bufnr] or 0) + 1
		local request = pending[bufnr]

		vim.defer_fn(function()
			if pending[bufnr] == request then
				select_parser(bufnr)
			end
		end, delay)
	end

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "rust",
		callback = function(args)
			schedule_parser(args.buf, 0)
		end,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
		group = group,
		pattern = "*",
		callback = function(args)
			if vim.bo[args.buf].filetype == "rust" then
				schedule_parser(args.buf, 0)
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = group,
		pattern = "*",
		callback = function(args)
			if vim.bo[args.buf].filetype == "rust" then
				schedule_parser(args.buf, 200)
			end
		end,
	})
end

return M
