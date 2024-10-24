return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("configs.conform")
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			filters = {
				dotfiles = false,
			},
			git = {
				enable = true,
			},
		},
	},

	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "svelte", "markdown" },
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-ts-autotag").setup({
				enable_rename = true,
				enable_close = true,
				enable_close_on_clash = true,
				filetypes = { "svelte", "html" },
			})
		end,
	},
	--
	{
		"IogaMaster/neocord",
		event = "VeryLazy",
		config = {
			main_image = "language",
			show_time = true,
			log_level = "debug",
			workspace_text = function()
				return "trying to exit vim"
			end,
		},
	},

	{
		"edgedb/edgedb-vim",
		lazy = false,
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			-- vim.g.rustfmt_autosave = 1
		end,
	},

	{
		"mfussenegger/nvim-dap",
		config = function()
			require("configs.dap")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			dofile(vim.g.base46_cache .. "dap")
			require("dapui").setup()
			require("configs.dap-ui")
		end,
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},
	{
		"mfussenegger/nvim-dap-python",
		commit = "3dffa58",
	},
	{
		"NvChad/ui",
		lazy = false,
		build = function()
			dofile(vim.fn.stdpath("data") .. "/lazy/ui/lua/nvchad_feedback.lua")()
		end,
	},
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	event = "InsertEnter",
	-- 	lazy = false,
	-- 	cmd = "Copilot",
	-- 	opts = require("configs.copilot"),
	-- },
	{
		"supermaven-inc/supermaven-nvim",
		-- commit = "df3ecf7",
		opts = require("configs.supermaven"),
		event = "InsertEnter",
		lazy = false,
		cmd = "Supermaven",
	},

	{
		"theprimeagen/harpoon",
		lazy = false,
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"html-lsp",
			},
		},
	},

	{
		"tpope/vim-fugitive",
		cmd = "Git",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"c",
				"nix",
				"markdown",
				"markdown_inline",
				"python",
				"rust",
				"proto",
				"yaml",
				"sql",
			},
			indent = {
				enable = true,
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
		config = function()
			require("configs.rustaceanvim")
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require(".configs.neotest")
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			plugins = {
				tmux = { enabled = true },
			},
		},
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		config = function()
			dofile(vim.g.base46_cache .. "trouble")
			require("trouble").setup()
		end,
	},
	{
		"nvim-neotest/neotest-python",
	},

	{
		"hrsh7th/nvim-cmp",
		opts = function()
			local conf = require("nvchad.configs.cmp")
			conf.mapping["<S-Tab>"] = nil
			conf.sources = {
				{ name = "nvim_lsp" },
				-- { name = "luasnip" },
				{ name = "buffer" },
				-- { name = "nvim_lua" },
				{ name = "vim-dadbod-completion" },
				{ name = "path" },
			}
		end,
	},

	{
		"NvChad/base46",
		-- dev = true,
		-- dir = "~/Projects/base46",
		build = function()
			require("base46").load_all_highlights()
		end,
	},
}
