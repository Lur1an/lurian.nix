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
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- set this if you want to always pull the latest change
		build = "make",
		opts = {
			provider = "openrouter-gemini-flash",
			cursor_applying_provider = "groq",
			rag_service = {
				enabled = false,
				host_mount = os.getenv("HOME"), -- Host mount path for the rag service
				provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
				llm_model = "llama3", -- The LLM model to use for RAG service
				embed_model = "", -- The embedding model to use for RAG service
			},
			providers = {
				ollama = {
					model = "devstral:latest",
				},
				["openrouter-grok"] = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "x-ai/grok-4",
				},
				["openrouter-gemini-flash"] = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "google/gemini-2.5-flash",
				},
				["openrouter-sonnet"] = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "anthropic/claude-sonnet-4",
				},
				["openrouter-opus"] = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "anthropic/claude-opus-4",
				},
				groq = { -- define groq provider
					__inherited_from = "openai",
					api_key_name = "GROQ_API_KEY",
					endpoint = "https://api.groq.com/openai/v1/",
					model = "anthropic/claude-sonnet-4",
					extra_request_body = {
						max_completion_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
					},
				},
			},
			behaviour = {
				auto_apply_diff_after_generation = true,
				enable_cursor_planning_mode = true,
			},
			windows = {
				position = "left",
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
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
	--
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
			{ "<M-o>", function() require("opencode").toggle() end, desc = "Toggle opencode", mode = { "n", "t" } },
			{ "<leader>oa", function() require("opencode").ask() end, desc = "Ask opencode", mode = "n" },
			{ "<leader>oa", function() require("opencode").ask("@selection: ") end, desc = "Ask opencode about selection", mode = "v" },
			{ "<leader>op", function() require("opencode").select_prompt() end, desc = "Select opencode prompt", mode = { "n", "v" } },
			{ "<leader>on", function() require("opencode").command("session_new") end, desc = "New opencode session" },
			{ "<leader>oy", function() require("opencode").command("messages_copy") end, desc = "Copy last opencode message" },
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
			auto_manage_context = true,  -- automatically manage buffer context
			default_bindings = false,    -- disable default <leader>A keybindings
			debug = false,               -- disable debug logging
			vim = true,                  -- enable vim mode
		},
		keys = {
			{ "<M-a>", function()
				-- Check if we're in an Aider buffer/window
				local bufname = vim.fn.bufname()
				if string.match(bufname, "term://.*aider") then
					-- Close the window if we're in Aider
					vim.cmd("close")
				else
					-- Open Aider if we're not
					vim.cmd("AiderOpen")
				end
			end, desc = "Toggle Aider", mode = { "n", "t" } },
		},
	},
}
