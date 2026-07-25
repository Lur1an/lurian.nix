return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.telescope")
		end,
	},
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
			vim.g.db_ui_env_variable_url = "DATABASE_URL"
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
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
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_rename = true,
					enable_close = true,
					enable_close_on_clash = true,
					filetypes = { "svelte", "html" },
				},
			})
		end,
	},
	{
		"IogaMaster/neocord",
		event = "VeryLazy",
		config = {
			main_image = "language",
			show_time = true,
			log_level = "error",
			workspace_text = function()
				return "I'd rather play games but idk how to exit this"
			end,
		},
	},
	{
		"geldata/edgedb-vim",
		lazy = false,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- author explicitly recommends NOT lazy-loading
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {},
	},
	{
		"Carus11/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npx --yes yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			require(".configs.dap")
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
		config = function()
			require("nvchad")
		end,
	},
	{
		"supermaven-inc/supermaven-nvim",
		-- commit = "df3ecf7",
		opts = require("configs.supermaven"),
		event = "InsertEnter",
		lazy = false,
		cmd = "Supermaven",
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- Basic snacks configuration
			notifier = { enabled = true },
			terminal = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
		},
	},

	{
		"NickvanDyke/opencode.nvim",
		dependencies = { "folke/snacks.nvim" },
		lazy = false,
		config = function()
			require("configs.opencode")
		end,
		keys = {
			{
				"<M-o>",
				function()
					require("configs.opencode").toggle()
				end,
				desc = "Toggle opencode",
				mode = { "n", "t" },
			},
			{
				"<leader>oa",
				function()
					require("opencode").ask("@this: ")
				end,
				desc = "Ask opencode",
				mode = { "n", "x" },
			}
		},
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

	-- nvim-treesitter is deprecated; replaced by tree-sitter-manager.nvim below.
	-- Disable NvChad's default nvim-treesitter spec (imported via nvchad.plugins).
	{ "nvim-treesitter/nvim-treesitter", enabled = false },

	{
		"romus204/tree-sitter-manager.nvim",
		lazy = false,
		cmd = { "TSManager", "TSInstall", "TSUninstall" },
		init = function()
			require("configs.verus-treesitter").setup()
		end,
		opts = {
			auto_install = true,
			highlight = true,
			ensure_installed = {
				"scheme",
				"query",
				"graphql",
				"vim",
				"lua",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"c",
				"helm",
				"nix",
				"markdown",
				"markdown_inline",
				"python",
				"rust",
				"verus",
				"proto",
				"yaml",
				"sql",
				"surrealql",
			},
			languages = {
				verus = {
					install_info = {
						url = "https://github.com/secure-foundations/tree-sitter-verus",
						use_repo_queries = true,
					},
				},
				surrealql = {
					install_info = {
						url = "https://github.com/surrealdb/surrealql-tree-sitter",
						branch = "tree-sitter-parity",
						use_repo_queries = true,
					},
				},
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
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
		},
		config = function()
			require(".configs.neotest")
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		init = function()
			-- Mappings are defined in mappings.lua so they win over NvChad defaults
			vim.g.tmux_navigator_no_mappings = 1
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				width = 150,
			},
			plugins = {
				tmux = { enabled = true },
			},
		},
	},
	{
		"folke/trouble.nvim",
		cmd = { "Trouble", "TodoTrouble" },
		lazy = false,
		dependencies = {
			{
				"folke/todo-comments.nvim",
				opts = {
					auto_jump = true,
					modes = {
						diagnostics = {
							auto_jump = true,
						},
					},
				},
			},
		},
		opts = {},
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
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "nvim_lua" },
				-- { name = "vim-dadbod-completion" },
				{ name = "path" },
				-- Add opencode completion in the ask input
				{ name = "opencode", filetype = "opencode_ask" },
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
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			routes = {
				{
					filter = {
						event = "notify",
						find = "different client offset_encodings",
					},
				},
				{
					filter = {
						event = "notify",
						find = "neocord",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "notify",
						find = "No information available",
					},
					opts = { skip = true },
				},
				{
					filter = {
						find = "Failed to subscribe to SSE: No `opencode` processes",
					},
					opts = { skip = true },
				},
				{
					filter = {
						find = "lines yanked",
					},
					opts = { skip = true },
				},
				{
					filter = {
						find = "more lines",
					},
					opts = { skip = true },
				},
				{
					filter = {
						find = "No errors",
					},
					opts = { skip = true },
				},
				{
					filter = {
						find = "No more items",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
			lsp = {
				signature = {
					enabled = false,
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			background_colour = "#000000",
		},
	},
	{
		"dlyongemallo/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
	},
	{
		"NvChad/WallSync",
		lazy = false,
		main = "wallsync",
		opts = {
			auto_start = true,
			-- Templates are managed declaratively via Nix (home-manager/wal/templates),
			-- and ~/.config/wal/templates is a read-only store symlink, so let WallSync
			-- skip its own (failing) template install.
			auto_install_templates = false,
			notify = true,
			debounce_ms = 500,
		},
	},
}
