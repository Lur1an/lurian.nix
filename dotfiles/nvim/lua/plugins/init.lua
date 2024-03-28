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
			git = { enable = true },
		},
	},

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-ts-autotag").setup()
			require("nvim-treesitter.configs").setup({
				autotag = {
					enable = true,
				},
			})
		end,
	},
	--
	-- {
	-- 	"IogaMaster/neocord",
	-- 	event = "VeryLazy",
	-- 	config = {
	-- 		main_image = "logo",
	-- 		logo = "https://0x0.st/H3Rh.png",
	-- 		show_time = true,
	-- 		log_level = "debug",
	-- 		workspace_text = function()
	-- 			return "Preparing +10000 lines PR"
	-- 		end,
	-- 	},
	-- },

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
			vim.g.rustfmt_autosave = 1
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		opts = require("configs.dap-ui"),
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			require("configs.dap")
		end,
	},

	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		lazy = false,
		cmd = "Copilot",
		opts = require("configs.copilot"),
	},

	{
		"theprimeagen/harpoon",
		lazy = false,
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
        "graphql-language-service-cli",
				"lua-language-server",
				"docker-compose-language-service",
				"dockerfile-language-server",
				"html-lsp",
				"prettier",
				"stylua",
				"tailwindcss-language-server",
				"typescript-language-server",
				"basedpyright",
        "pyright",
        "debugpy",
        "black",
				"marksman",
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
			require("configs.neotest")
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
		"Lur1an/base46",
		branch = "v2.5",
		build = function()
			require("base46").load_all_highlights()
		end,
	},
	{
		"towolf/vim-helm",
	},
}
