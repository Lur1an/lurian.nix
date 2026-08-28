{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (import ./helpers.nix) luaExpr luaFn;

  debugpyPython = pkgs.python3.withPackages (pythonPackages: [pythonPackages.debugpy]);
  debugpyPythonExe = lib.getExe debugpyPython;

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
  programs.nixvim = {
    extraFiles."lua/nixvim/plugins.lua".source = ../../dotfiles/nvim/lua/nixvim/plugins.lua;
    globals.nixvim_debugpy_python = debugpyPythonExe;

    extraPlugins = [
      pkgs.vimPlugins.edgedb-vim
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
        enable = true;
        package = pkgs.docker-compose-language-service;
      };
      dockerls = {
        enable = true;
        package = pkgs.dockerfile-language-server;
      };
      tailwindcss = {
        enable = true;
        package = pkgs.tailwindcss-language-server;
      };
      svelte = {
        enable = true;
        package = pkgs.svelte-language-server;
      };
      lua_ls = {
        enable = true;
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
        enable = true;
        package = pkgs.terraform-ls;
      };
      ts_ls = {
        enable = true;
        package = pkgs.typescript-language-server;
      };
      just = {
        enable = true;
        package = pkgs.just-lsp;
      };
      ruff = {
        enable = true;
        package = pkgs.ruff;
      };
      nixd = {
        enable = true;
        package = pkgs.nixd;
      };
      helm_ls = {
        enable = true;
        package = pkgs.helm-ls;
      };
      marksman = {
        enable = true;
        package = pkgs.marksman;
      };
      html = {
        enable = true;
        package = pkgs.vscode-langservers-extracted;
      };
      basedpyright = {
        enable = true;
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
      web-devicons = {
        enable = true;
        settings.override = luaFn {
          module = "plugins";
          function = "devicons";
        };
      };

      indent-blankline = {
        enable = true;
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
        enable = true;
        settings = luaFn {
          module = "plugins";
          function = "gitsigns_settings";
          call = true;
        };
      };

      which-key = {
        enable = true;
        settings = {};
      };

      nvim-tree = {
        enable = true;
        settings = luaFn {
          module = "plugins";
          function = "nvim_tree_settings";
          call = true;
        };
      };

      telescope = {
        enable = true;
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

      vim-dadbod.enable = true;
      vim-dadbod-completion.enable = true;
      vim-dadbod-ui.enable = true;
      lspconfig.enable = true;

      conform-nvim = {
        enable = true;
        settings = {
          yamlfix.env = {
            YAMLFIX_SEQUENCE_STYLE = "block_style";
            YAMLFIX_EXPLICIT_START = "false";
            YAMLFIX_WHITELINES = "1";
          };
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
        enable = true;
        settings.opts = {
          enable_rename = true;
          enable_close = true;
          enable_close_on_clash = true;
          filetypes = ["svelte" "html"];
        };
      };

      neocord = {
        enable = true;
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
        enable = true;
        settings = {};
      };

      markdown-preview = {
        enable = true;
        package = pkgs.vimPlugins.markdown-preview-nvim;
        settings.filetypes = ["markdown"];
      };

      dap = {
        enable = true;
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
        enable = true;
        settings = {};
      };

      dap-python = {
        enable = true;
        adapterPythonPath = debugpyPythonExe;
      };

      supermaven = {
        enable = true;
        settings.keymaps.accept_suggestion = "<S-Tab>";
      };

      snacks = {
        enable = true;
        settings = {
          notifier.enabled = true;
          terminal.enabled = true;
          input.enabled = true;
          picker.enabled = true;
        };
      };

      opencode = {
        enable = true;
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

      harpoon.enable = true;
      fugitive.enable = true;
      rustaceanvim.enable = true;

      neotest = {
        enable = true;
        settings.adapters = [
          (luaExpr {
            module = "plugins";
            function = "rustacean_neotest";
            call = true;
          })
        ];
        adapters.python = {
          enable = true;
          settings.dap.justMyCode = true;
        };
      };

      tmux-navigator = {
        enable = true;
        settings.no_mappings = 1;
      };

      zen-mode = {
        enable = true;
        settings = {
          window.width = 150;
          plugins.tmux.enabled = true;
        };
      };

      trouble = {
        enable = true;
        settings = {};
      };

      todo-comments = {
        enable = true;
        settings = {
          auto_jump = true;
          modes.diagnostics.auto_jump = true;
        };
      };

      cmp = {
        enable = true;
        settings = luaFn {
          module = "plugins";
          function = "cmp_settings";
          call = true;
        };
      };

      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      cmp-buffer.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-async-path.enable = true;

      luasnip = {
        enable = true;
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

      friendly-snippets.enable = true;

      nvim-autopairs = {
        enable = true;
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

      nui.enable = true;

      noice = {
        enable = true;
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
        enable = true;
        settings.background_colour = "#000000";
      };

      diffview = {
        enable = true;
        package = pkgs.vimPlugins.diffview-plus-nvim;
      };

      treesitter = {
        enable = true;
        highlight.enable = true;
        grammarPackages =
          standardGrammars
          ++ [
            pkgs.nixvimPackages.tree-sitter-verus
            pkgs.nixvimPackages.tree-sitter-surrealql
          ];
      };
    };
  };

  home.sessionVariables.XDG_DATA_HOME = config.xdg.dataHome;

  xdg.dataFile."supermaven/binary/v20/linux-x86_64/sm-agent" = {
    source = "${pkgs.nixvimPackages.supermaven-agent}/bin/sm-agent";
    force = true;
  };
}
