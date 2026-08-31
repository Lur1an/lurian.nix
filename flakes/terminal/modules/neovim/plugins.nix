{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./helpers.pkg.nix) luaExpr luaFn;

  debugpyPython = pkgs.python3.withPackages (pythonPackages: [pythonPackages.debugpy]);
  debugpyPythonExe = lib.getExe debugpyPython;
  treeSitterVerus = pkgs.callPackage ./tree-sitter-verus.pkg.nix {};
  treeSitterSurrealql = pkgs.callPackage ./tree-sitter-surrealql.pkg.nix {};
  supermavenAgent = pkgs.callPackage ./supermaven-agent.pkg.nix {};

  standardGrammarNames = [
    "diff"
    "git_config"
    "cmake"
    "jq"
    "go"
    "powershell"
    "csv"
    "tsv"
    "cpp"
    "pem"
    "hcl"
    "terraform"
    "requirements"
    "dockerfile"
    "gitcommit"
    "svelte"
    "htmldjango"
    "just"
    "rasi"
    "qmljs"
    "ini"
    "bash"
    "xml"
    "dtd"
    "gitattributes"
    "toml"
    "json"
    "gitignore"
    "sql"
    "vim"
    "tsx"
    "typescript"
    "rust"
    "markdown_inline"
    "markdown"
    "javascript"
    "python"
    "helm"
    "c"
    "yaml"
    "nix"
    "css"
    "proto"
    "scheme"
    "lua"
    "html"
    "graphql"
    "query"
  ];

  standardGrammars =
    map (name: pkgs.vimPlugins.nvim-treesitter.builtGrammars.${name})
    standardGrammarNames;
in {
  options.programs.nixvim.plugins = {
    nvchad.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the coupled NvChad plugin stack";
    };
    edgedb-vim.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable EdgeDB Vim syntax support";
    };
  };
  config = lib.mkIf config.lurian.terminal.neovim.enable {
    programs.nixvim = {
      extraFiles."lua/nixvim/plugins.lua".source = ./files/lua/nixvim/plugins.lua;
      globals = {
        nixvim_debugpy_python = debugpyPythonExe;
        lurian_features = {
          nvchad = config.programs.nixvim.plugins.nvchad.enable;
          telescope = config.programs.nixvim.plugins.telescope.enable;
          trouble = config.programs.nixvim.plugins.trouble.enable;
          cmp = config.programs.nixvim.plugins.cmp.enable;
          dap = config.programs.nixvim.plugins.dap.enable;
          dap_ui = config.programs.nixvim.plugins.dap-ui.enable;
          opencode = config.programs.nixvim.plugins.opencode.enable;
          snacks = config.programs.nixvim.plugins.snacks.enable;
          treesitter = config.programs.nixvim.plugins.treesitter.enable;
          luasnip = config.programs.nixvim.plugins.luasnip.enable;
          autopairs = config.programs.nixvim.plugins.nvim-autopairs.enable;
          rustaceanvim = config.programs.nixvim.plugins.rustaceanvim.enable;
          neotest = config.programs.nixvim.plugins.neotest.enable;
        };
      };

      extraPlugins =
        lib.optionals config.programs.nixvim.plugins.edgedb-vim.enable [pkgs.vimPlugins.edgedb-vim]
        ++ [
          pkgs.vimPlugins.plenary-nvim
          pkgs.vimPlugins.nvim-nio
          pkgs.vimPlugins.FixCursorHold-nvim
        ];

      extraPackages = [
        debugpyPython
        pkgs.graphql-language-service-cli
        pkgs.isort
        pkgs.prettier
        pkgs.ripgrep
        pkgs.stylua
        pkgs.yaml-language-server
        pkgs.yamlfix
      ];

      lsp.servers = {
        docker_compose_language_service = {
          enable = lib.mkDefault true;
          package = pkgs.docker-compose-language-service;
        };
        dockerls = {
          enable = lib.mkDefault true;
          package = pkgs.dockerfile-language-server;
        };
        tailwindcss = {
          enable = lib.mkDefault true;
          package = pkgs.tailwindcss-language-server;
        };
        svelte = {
          enable = lib.mkDefault true;
          package = pkgs.svelte-language-server;
        };
        lua_ls = {
          enable = lib.mkDefault true;
          package = pkgs.lua-language-server;
          config.settings.Lua = {
            runtime.version = "LuaJIT";
            workspace.library = luaFn {
              module = "plugins";
              function = "lua_runtime_library";
              call = true;
            };
          };
        };
        terraformls = {
          enable = lib.mkDefault true;
          package = pkgs.terraform-ls;
        };
        ts_ls = {
          enable = lib.mkDefault true;
          package = pkgs.typescript-language-server;
        };
        just = {
          enable = lib.mkDefault true;
          package = pkgs.just-lsp;
        };
        ruff = {
          enable = lib.mkDefault true;
          package = pkgs.ruff;
        };
        nixd = {
          enable = lib.mkDefault true;
          package = pkgs.nixd;
        };
        helm_ls = {
          enable = lib.mkDefault true;
          package = pkgs.helm-ls;
        };
        marksman = {
          enable = lib.mkDefault true;
          package = pkgs.marksman;
        };
        html = {
          enable = lib.mkDefault true;
          package = pkgs.vscode-langservers-extracted;
        };
        basedpyright = {
          enable = lib.mkDefault true;
          package = pkgs.basedpyright;
          config.settings.basedpyright.analysis = {
            diagnosticMode = "workspace";
            extraPaths = ["./.devenv/state/venv/lib/python3.12/site-packages"];
            typeCheckingMode = "basic";
            reportMissingTypeStubs = false;
          };
        };
      };

      plugins = {
        nvchad.enable = lib.mkDefault true;
        edgedb-vim.enable = lib.mkDefault true;
        web-devicons = {
          enable = lib.mkDefault true;
          settings.override = luaFn {
            module = "plugins";
            function = "devicons";
          };
        };

        indent-blankline = {
          enable = lib.mkDefault true;
          settings = {
            indent = {
              char = "│";
              highlight = "IblChar";
            };
            scope = {
              char = "│";
              highlight = "IblScopeChar";
            };
          };
          luaConfig.pre = luaExpr {
            module = "plugins";
            function = "setup_indent_blankline";
            call = true;
          };
        };

        gitsigns = {
          enable = lib.mkDefault true;
          settings = luaFn {
            module = "plugins";
            function = "gitsigns_settings";
            call = true;
          };
        };

        which-key = {
          enable = lib.mkDefault true;
          settings = {};
        };

        nvim-tree = {
          enable = lib.mkDefault true;
          settings = luaFn {
            module = "plugins";
            function = "nvim_tree_settings";
            call = true;
          };
        };

        telescope = {
          enable = lib.mkDefault true;
          settings = luaFn {
            module = "plugins";
            function = "telescope_settings";
            call = true;
          };
          luaConfig.post = luaExpr {
            module = "plugins";
            function = "setup_telescope_extensions";
            call = true;
          };
        };

        vim-dadbod.enable = lib.mkDefault true;
        vim-dadbod-completion.enable = lib.mkDefault true;
        vim-dadbod-ui.enable = lib.mkDefault true;
        lspconfig.enable = lib.mkDefault true;

        conform-nvim = {
          enable = lib.mkDefault true;
          settings = {
            yamlfix.env = {
              YAMLFIX_SEQUENCE_STYLE = "block_style";
              YAMLFIX_EXPLICIT_START = "false";
              YAMLFIX_WHITELINES = "1";
            };
            formatters.rustfmt.options.nightly = true;
            format_on_save = luaFn {
              module = "plugins";
              function = "conform_format_on_save";
            };
            formatters_by_ft = {
              lua = ["stylua"];
              python = ["ruff_fix" "ruff_format"];
              rust = ["rustfmt"];
              typescript = ["prettier"];
              svelte = ["prettier"];
              html = ["prettier"];
              graphql = ["prettier"];
              css = ["prettier"];
              yaml = ["prettier"];
              json = ["prettier"];
              javascript = ["prettier"];
            };
          };
        };

        ts-autotag = {
          enable = lib.mkDefault true;
          settings.opts = {
            enable_rename = true;
            enable_close = true;
            enable_close_on_clash = true;
            filetypes = ["svelte" "html"];
          };
        };

        neocord = {
          enable = lib.mkDefault true;
          settings = {
            main_image = "language";
            show_time = true;
            log_level = "error";
            workspace_text = luaFn {
              module = "plugins";
              function = "neocord_workspace_text";
            };
          };
        };

        markview = {
          enable = lib.mkDefault true;
          settings = {};
        };

        markdown-preview = {
          enable = lib.mkDefault true;
          package = pkgs.vimPlugins.markdown-preview-nvim;
          settings.filetypes = ["markdown"];
        };

        dap = {
          enable = lib.mkDefault true;
          adapters.python = luaFn {
            module = "plugins";
            function = "python_dap_adapter";
          };
          signs = {
            dapBreakpoint = {
              text = "";
              texthl = "DapBreakpoint";
              linehl = "DapBreakpoint";
              numhl = "DapBreakpoint";
            };
            dapBreakpointCondition = {
              text = "ﳁ";
              texthl = "DapBreakpoint";
              linehl = "DapBreakpoint";
              numhl = "DapBreakpoint";
            };
            dapBreakpointRejected = {
              text = "";
              texthl = "DapBreakpoint";
              linehl = "DapBreakpoint";
              numhl = "DapBreakpoint";
            };
            dapLogPoint = {
              text = "";
              texthl = "DapLogPoint";
              linehl = "DapLogPoint";
              numhl = "DapLogPoint";
            };
            dapStopped = {
              text = "";
              texthl = "DapStopped";
              linehl = "DapStopped";
              numhl = "DapStopped";
            };
          };
        };

        dap-ui = {
          enable = lib.mkDefault true;
          settings = {};
        };

        dap-python = {
          enable = lib.mkDefault true;
          adapterPythonPath = debugpyPythonExe;
        };

        supermaven = {
          enable = lib.mkDefault (pkgs.stdenv.hostPlatform.system == "x86_64-linux");
          settings.keymaps.accept_suggestion = "<S-Tab>";
        };

        snacks = {
          enable = lib.mkDefault true;
          settings = {
            notifier.enabled = true;
            terminal.enabled = true;
            input.enabled = true;
            picker.enabled = true;
          };
        };

        opencode = {
          enable = lib.mkDefault true;
          settings = {
            server.start = luaFn {
              module = "plugins";
              function = "opencode_start";
            };
            contexts."@git" = luaFn {
              module = "plugins";
              function = "opencode_git_context";
            };
            select.prompts.refactor = "Refactor @this to improve readability and maintainability";
            events = {
              enabled = true;
              reload.enabled = true;
            };
          };
        };

        harpoon.enable = lib.mkDefault true;
        fugitive.enable = lib.mkDefault true;
        rustaceanvim.enable = lib.mkDefault true;

        neotest = {
          enable = lib.mkDefault true;
          settings.adapters = [
            (luaExpr {
              module = "plugins";
              function = "rustacean_neotest";
              call = true;
            })
          ];
          adapters.python = {
            enable = lib.mkDefault true;
            settings.dap.justMyCode = true;
          };
        };

        tmux-navigator = {
          enable = lib.mkDefault true;
          settings.no_mappings = 1;
        };

        zen-mode = {
          enable = lib.mkDefault true;
          settings = {
            window.width = 150;
            plugins.tmux.enabled = true;
          };
        };

        trouble = {
          enable = lib.mkDefault true;
          settings = {};
        };

        todo-comments = {
          enable = lib.mkDefault true;
          settings = {
            auto_jump = true;
            modes.diagnostics.auto_jump = true;
          };
        };

        cmp = {
          enable = lib.mkDefault true;
          settings = luaFn {
            module = "plugins";
            function = "cmp_settings";
            call = true;
          };
        };

        cmp-nvim-lsp.enable = lib.mkDefault true;
        cmp_luasnip.enable = lib.mkDefault true;
        cmp-buffer.enable = lib.mkDefault true;
        cmp-nvim-lua.enable = lib.mkDefault true;
        cmp-async-path.enable = lib.mkDefault true;

        luasnip = {
          enable = lib.mkDefault true;
          settings = {
            history = true;
            update_events = "TextChanged,TextChangedI";
          };
          luaConfig.post = luaExpr {
            module = "plugins";
            function = "setup_luasnip";
            call = true;
          };
        };

        friendly-snippets.enable = lib.mkDefault true;

        nvim-autopairs = {
          enable = lib.mkDefault true;
          settings = {
            fast_wrap = {};
            disable_filetype = ["TelescopePrompt" "vim"];
          };
          luaConfig.post = luaExpr {
            module = "plugins";
            function = "setup_cmp_autopairs";
            call = true;
          };
        };

        nui.enable = lib.mkDefault true;

        noice = {
          enable = lib.mkDefault true;
          settings = {
            routes = [
              {
                filter = {
                  event = "notify";
                  find = "different client offset_encodings";
                };
              }
              {
                filter = {
                  event = "notify";
                  find = "neocord";
                };
                opts.skip = true;
              }
              {
                filter = {
                  event = "notify";
                  find = "No information available";
                };
                opts.skip = true;
              }
              {
                filter.find = "Failed to subscribe to SSE: No `opencode` processes";
                opts.skip = true;
              }
              {
                filter.find = "lines yanked";
                opts.skip = true;
              }
              {
                filter.find = "more lines";
                opts.skip = true;
              }
              {
                filter.find = "No errors";
                opts.skip = true;
              }
              {
                filter.find = "No more items";
                opts.skip = true;
              }
              {
                filter = {
                  event = "msg_show";
                  kind = "";
                  find = "written";
                };
                opts.skip = true;
              }
            ];
            lsp = {
              signature.enabled = false;
              override = {
                "vim.lsp.util.convert_input_to_markdown_lines" = true;
                "vim.lsp.util.stylize_markdown" = true;
                "cmp.entry.get_documentation" = true;
              };
            };
            presets = {
              bottom_search = true;
              command_palette = false;
              long_message_to_split = true;
              inc_rename = false;
              lsp_doc_border = false;
            };
          };
        };

        notify = {
          enable = lib.mkDefault true;
          settings.background_colour = "#000000";
        };

        diffview = {
          enable = lib.mkDefault true;
          package = pkgs.vimPlugins.diffview-plus-nvim;
        };

        treesitter = {
          enable = lib.mkDefault true;
          highlight.enable = lib.mkDefault true;
          grammarPackages =
            standardGrammars
            ++ [
              treeSitterVerus
              treeSitterSurrealql
            ];
        };
      };
    };

    home.sessionVariables.XDG_DATA_HOME = config.xdg.dataHome;

    assertions = [
      {
        assertion =
          !config.programs.nixvim.plugins.supermaven.enable
          || pkgs.stdenv.hostPlatform.system == "x86_64-linux";
        message = "Supermaven is only supported on x86_64-linux";
      }
    ];
    xdg.dataFile."supermaven/binary/v20/linux-x86_64/sm-agent" = lib.mkIf config.programs.nixvim.plugins.supermaven.enable {
      source = "${supermavenAgent}/bin/sm-agent";
      force = true;
    };
  };
}
