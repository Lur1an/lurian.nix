return {
	{
		"nvim-treesitter/playground",
		cmd = {
			"TSPlaygroundToggle",
		},
	},
	{
		"dariuscorvus/tree-sitter-surrealdb.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		config = function()
			-- setup step
			require("tree-sitter-surrealdb").setup()
		end,
	},
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
					require("opencode").toggle()
					-- Focus the opencode terminal window after toggling
					vim.schedule(function()
						local wins = vim.api.nvim_list_wins()
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							local buf_name = vim.api.nvim_buf_get_name(buf)
							-- Check if this is the opencode terminal
							if
								vim.bo[buf].buftype == "terminal"
								and (buf_name:match("opencode") or buf_name:match("term://.*opencode"))
							then
								vim.api.nvim_set_current_win(win)
								-- Enter insert mode if we're in normal mode
								if vim.fn.mode() == "n" then
									vim.cmd("startinsert")
								end
								break
							end
						end
					end)
				end,
				desc = "Toggle opencode",
				mode = { "n", "t" },
			},
			{
				"<leader>oa",
				function()
					require("opencode").ask()
				end,
				desc = "Ask opencode",
				mode = "n",
			},
			{
				"<leader>oa",
				function()
					require("opencode").ask("@selection: ")
				end,
				desc = "Ask opencode about selection",
				mode = "v",
			},
			{
				"<leader>op",
				function()
					require("opencode").select_prompt()
				end,
				desc = "Select opencode prompt",
				mode = { "n", "v" },
			},
			{
				"<leader>on",
				function()
					require("opencode").command("session_new")
				end,
				desc = "New opencode session",
			},
			{
				"<leader>oy",
				function()
					require("opencode").command("messages_copy")
				end,
				desc = "Copy last opencode message",
			},
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

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			injections = {
				enable = true,
			},
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
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require(".configs.neotest")
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
				command_palette = true, -- position the cmdline and popupmenu together
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
		"joshuavial/aider.nvim",
		lazy = false,
		opts = {
			auto_manage_context = true, -- automatically manage buffer context
			default_bindings = false, -- disable default <leader>A keybindings
			debug = false, -- disable debug logging
			vim = true, -- enable vim mode
		},
		keys = {
			{
				"<M-a>",
				function()
					-- Check if we're in an Aider buffer/window
					local bufname = vim.fn.bufname()
					if string.match(bufname, "term://.*aider") then
						-- Close the window if we're in Aider
						vim.cmd("close")
					else
						-- Open Aider if we're not
						vim.cmd("AiderOpen")
					end
				end,
				desc = "Toggle Aider",
				mode = { "n", "t" },
			},
		},
	},
}
