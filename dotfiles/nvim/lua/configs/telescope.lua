local open_with_trouble = require("trouble.sources.telescope").open

require("telescope").setup({
	defaults = {
		prompt_prefix = "   ",
		selection_caret = " ",
		entry_prefix = " ",
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
			},
			width = 0.87,
			height = 0.80,
		},
		extensions_list = { "themes", "terms" },
		extensions = {},
		mappings = {
			i = { ["<c-t>"] = open_with_trouble },
			n = { ["<c-t>"] = open_with_trouble, ["q"] = require("telescope.actions").close },
		},
	},
})
