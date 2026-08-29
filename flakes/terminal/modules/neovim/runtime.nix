{...}: {
  config.terminal.homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (import ./helpers.pkg.nix) luaExpr luaFn;
  in {
    config = lib.mkIf config.lurian.terminal.neovim.enable {
      programs.nixvim = {
        opts = {
          clipboard = "unnamedplus";
          expandtab = true;
          shiftwidth = 4;
          smartindent = true;
          tabstop = 4;
          softtabstop = 4;
          relativenumber = true;
          incsearch = true;
          foldmethod = "expr";
          foldexpr = "v:lua.vim.treesitter.foldexpr()";
          foldenable = true;
          foldlevelstart = 99;
        };

        globals = {
          db_ui_env_variable_url = "DATABASE_URL";
          db_ui_use_nerd_fonts = 1;
        };

        filetype = {
          extension = {
            mdx = "mdx";
            surql = "surrealql";
            surrealql = "surrealql";
          };
          pattern = {
            ".*gel" = "edgeql";
            ".*/templates/.*%.yaml" = "helm";
            ".*/templates/.*%.tpl" = "helm";
            ".*/.kube/config" = "yaml";
            ".*/kubeconfig" = "yaml";
          };
        };

        diagnostic.settings.virtual_text = true;

        userCommands.WatchCommand = {
          command = luaFn {
            module = "custom";
            function = "watch_command";
            namespace = null;
          };
          nargs = "+";
          complete = "shellcmd";
          desc = "Watch a shell command and update buffer on output change";
        };

        lsp.servers."*".config = {
          on_init = luaFn {
            module = "nvchad.configs.lspconfig";
            function = "on_init";
            namespace = null;
          };
          capabilities = luaFn {
            module = "nvchad.configs.lspconfig";
            function = "capabilities";
            namespace = null;
          };
          on_attach = luaFn {
            module = "runtime";
            function = "lsp_on_attach";
          };
        };

        plugins = {
          rustaceanvim.settings = {
            tools = {};
            server = {
              flags = {
                exit_timeout = 0;
                debounce_text_changes = 450;
              };
              on_init = luaFn {
                module = "nvchad.configs.lspconfig";
                function = "on_init";
                namespace = null;
              };
              capabilities = luaFn {
                module = "nvchad.configs.lspconfig";
                function = "capabilities";
                namespace = null;
              };
              on_attach = luaFn {
                module = "runtime";
                function = "rust_on_attach";
              };
              default_settings."rust-analyzer" = {
                assist = {
                  importGranularity = "module";
                  importPrefix = "by_self";
                };
                cargo = {
                  buildScripts.enable = true;
                  allFeatures = true;
                };
                procMacro.enable = true;
              };
            };
            dap.adapter = luaFn {
              module = "runtime";
              function = "rust_dap_adapter";
              call = true;
            };
          };
        };

        extraFiles = {
          "lua/custom.lua".source = ./files/lua/custom.lua;
          "lua/nixvim/runtime.lua".source = ./files/lua/nixvim/runtime.lua;
          "lua/nixvim/nvchad.lua".source = ./files/lua/nixvim/nvchad.lua;
          "lua/configs/verus-treesitter.lua".source = ./files/lua/configs/verus-treesitter.lua;

          "after/ftplugin/edgeql.lua".source = ./files/after/ftplugin/edgeql.lua;
          "after/ftplugin/graphql.lua".source = ./files/after/ftplugin/graphql.lua;
          "after/ftplugin/helm.lua".source = ./files/after/ftplugin/helm.lua;
          "after/ftplugin/html.lua".source = ./files/after/ftplugin/html.lua;
          "after/ftplugin/json.lua".source = ./files/after/ftplugin/json.lua;
          "after/ftplugin/lua.lua".source = ./files/after/ftplugin/lua.lua;
          "after/ftplugin/nix.lua".source = ./files/after/ftplugin/nix.lua;
          "after/ftplugin/typescript.lua".source = ./files/after/ftplugin/typescript.lua;
          "after/ftplugin/yaml.lua".source = ./files/after/ftplugin/yaml.lua;

          "after/queries/yaml/injections.scm".source = ./files/after/queries/yaml/injections.scm;
          "after/queries/verus/highlights.scm".source = ./files/after/queries/verus/highlights.scm;
          "after/queries/python/injections.scm".source = ./files/after/queries/python/injections.scm;
          "after/queries/rust/injections.scm".source = ./files/after/queries/rust/injections.scm;
          "after/queries/markdown/injections.scm".source = ./files/after/queries/markdown/injections.scm;
          "after/queries/markdown/highlights.scm".source = ./files/after/queries/markdown/highlights.scm;
        };

        extraConfigLuaPre = lib.mkAfter (luaExpr {
          module = "runtime";
          function = "pre";
          call = true;
        });

        extraConfigLuaPost = lib.mkAfter (luaExpr {
          module = "runtime";
          function = "post";
          call = true;
        });
      };
    };
  };
}
