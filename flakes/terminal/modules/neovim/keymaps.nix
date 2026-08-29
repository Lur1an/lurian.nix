{...}: {
  config.terminal.homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (import ./helpers.pkg.nix) luaFn;
  in {
    config = lib.mkIf config.lurian.terminal.neovim.enable {
      programs.nixvim = {
        extraFiles."lua/nixvim/keymaps.lua".source = ./files/lua/nixvim/keymaps.lua;

        keymaps = [
          # Local Telescope notification picker.
          {
            mode = "n";
            key = "<leader>fn";
            action = "<cmd>Telescope notify<CR>";
            options.desc = "Telescope find notifications";
          }

          # Local formatting, diagnostics, database, DAP, and Neotest mappings.
          {
            mode = "n";
            key = "<leader>rl";
            action = "<cmd>edit!<CR>";
            options.desc = "reload file";
          }
          {
            mode = "n";
            key = "]d";
            action = luaFn {
              module = "keymaps";
              function = "jump_to_next_diagnostic";
            };
            options.desc = "jump to next diagnostic";
          }
          {
            mode = "n";
            key = "[d";
            action = luaFn {
              module = "keymaps";
              function = "jump_to_previous_diagnostic";
            };
            options.desc = "jump to previous diagnostic";
          }
          {
            mode = "n";
            key = "<leader>fm";
            action = luaFn {
              module = "keymaps";
              function = "file_format_with_conform";
            };
            options.desc = "File Format with conform";
          }
          {
            mode = "n";
            key = "<leader>db";
            action = "<cmd>DBUIToggle<CR>";
            options.desc = "DBUIToggle toggle DBUI";
          }
          {
            mode = "n";
            key = "<leader>dl";
            action = luaFn {
              module = "keymaps";
              function = "dap_run_last_test";
            };
            options.desc = "dap run last test";
          }
          {
            mode = "n";
            key = "<leader>cb";
            action = luaFn {
              module = "keymaps";
              function = "dap_conditional_breakpoint";
            };
          }
          {
            mode = "n";
            key = "<C-y>";
            action = luaFn {
              module = "keymaps";
              function = "dap_toggle_ui";
            };
            options.desc = "dap toggle UI";
          }
          {
            mode = "n";
            key = "<leader>b";
            action = luaFn {
              module = "keymaps";
              function = "dap_toggle_breakpoint";
            };
            options.desc = "dap toggle breakpoint";
          }
          {
            mode = "n";
            key = "<F9>";
            action = luaFn {
              module = "keymaps";
              function = "dap_debug_test";
            };
            options.desc = "dap debug test";
          }
          {
            mode = "n";
            key = "<F10>";
            action = luaFn {
              module = "keymaps";
              function = "dap_step_over";
            };
            options.desc = "dap step over";
          }
          {
            mode = "n";
            key = "<F5>";
            action = luaFn {
              module = "keymaps";
              function = "dap_continue";
            };
            options.desc = "dap continue";
          }
          {
            mode = "n";
            key = "<S-F5>";
            action = luaFn {
              module = "keymaps";
              function = "dap_restart";
            };
            options.desc = "dap restart";
          }
          {
            mode = "n";
            key = "<F17>";
            action = luaFn {
              module = "keymaps";
              function = "dap_restart_2";
            };
            options.desc = "dap restart";
          }
          {
            mode = "n";
            key = "<F8>";
            action = luaFn {
              module = "keymaps";
              function = "dap_terminate";
            };
            options.desc = "dap terminate";
          }
          {
            mode = "v";
            key = "<C-k>";
            action = luaFn {
              module = "keymaps";
              function = "dap_evaluate_selection";
            };
            options.desc = "dap evaluate selection";
          }
          {
            mode = "n";
            key = "<leader>rt";
            action = luaFn {
              module = "keymaps";
              function = "neotest_run_nearest_test";
            };
            options.desc = "neotest run nearest test";
          }
          {
            mode = "n";
            key = "<leader>dt";
            action = luaFn {
              module = "keymaps";
              function = "neotest_debug_nearest_test";
            };
            options.desc = "neotest debug nearest test";
          }

          # General editing behavior.
          {
            mode = ["n" "v"];
            key = "$";
            action = "g_";
            options.desc = "general move to end of line";
          }
          {
            mode = "n";
            key = ";";
            action = ":";
            options.desc = "CMD enter command mode";
          }
          {
            mode = "n";
            key = "q";
            action = luaFn {
              module = "keymaps";
              function = "general_close_buffer";
            };
            options.desc = "general close buffer";
          }
          {
            mode = "n";
            key = "j";
            action = ''v:count > 1 ? "jzz" : "j"'';
            options = {
              desc = "numbered jump with centering";
              expr = true;
              noremap = true;
            };
          }
          {
            mode = "n";
            key = "k";
            action = ''v:count > 1 ? "kzz" : "k"'';
            options = {
              desc = "numbered jump with centering";
              expr = true;
              noremap = true;
            };
          }
          {
            mode = "n";
            key = "n";
            action = "nzzzv";
            options.desc = "general find next occurrence";
          }
          {
            mode = "n";
            key = "N";
            action = "Nzzzv";
            options.desc = "general find previous occurrence";
          }
          {
            mode = "n";
            key = "Q";
            action = ":only<CR>";
            options.desc = "close other windows";
          }
          {
            mode = "n";
            key = "<leader>j";
            action = ":lnext<CR>zz";
            options.desc = "general location next";
          }
          {
            mode = "n";
            key = "<leader>k";
            action = ":lprev<CR>zz";
            options.desc = "general location previous";
          }
          {
            mode = "n";
            key = "<leader>s";
            action = "<cmd>w<CR>";
            options.desc = "general save file";
          }
          {
            mode = "i";
            key = "<C-c>";
            action = "<cmd>w<CR><Esc>";
            options.desc = "general save and exit insert mode";
          }
          {
            mode = "n";
            key = "<M-j>";
            action = ":cn<CR>zz";
            options.desc = "general quickfix next";
          }
          {
            mode = "n";
            key = "<M-k>";
            action = ":cp<CR>zz";
            options.desc = "general quickfix previous";
          }
          {
            mode = ["n" "t"];
            key = "<M-u>";
            action = luaFn {
              module = "keymaps";
              function = "toggle_k9s";
            };
            options.desc = "toggle k9s";
          }
          {
            mode = "n";
            key = "<C-u>";
            action = "<C-u>zz";
            options.desc = "general scroll up";
          }
          {
            mode = "n";
            key = "<C-d>";
            action = "<C-d>zz";
            options.desc = "general scroll down";
          }
          {
            mode = ["n" "v"];
            key = "<leader>d";
            action = ''"_d'';
            options.desc = "general delete into void";
          }
          {
            mode = "n";
            key = "<C-o>";
            action = "<C-o>zz";
            options.desc = "general jump back (with line centering)";
          }
          {
            mode = "n";
            key = "<C-i>";
            action = "<C-i>zz";
            options.desc = "general jump forward (with line centering)";
          }
          {
            mode = "v";
            key = "K";
            action = ":m'<-2<CR>gv=gv";
            options.desc = "general move selection up";
          }
          {
            mode = "v";
            key = "J";
            action = ":m'>+1<CR>gv=gv";
            options.desc = "general move selection down";
          }
          {
            mode = "v";
            key = "(";
            action = "c()<C-c>P";
            options.desc = "general surround with '()'";
          }
          {
            mode = "v";
            key = "{";
            action = "c{}<C-c>P";
            options.desc = "general surround with '{}'";
          }
          {
            mode = "v";
            key = "[";
            action = "c[]<C-c>P";
            options.desc = "general surround with '[]'";
          }
          {
            mode = "v";
            key = "'";
            action = "c''<C-c>P";
            options.desc = "general surround with single quotes";
          }
          {
            mode = "v";
            key = ''"'';
            action = ''c""<C-c>P'';
            options.desc = "general surround with double quotes";
          }
          {
            mode = "v";
            key = "`";
            action = "c``<C-c>P";
            options.desc = "general surround with backticks";
          }
          {
            mode = "v";
            key = "<leader>p";
            action = ''"_p'';
            options.desc = "general paste and delete previous into void";
          }

          # Harpoon. <C-g> intentionally belongs only to Fugitive below; file 4 was overwritten.
          {
            mode = "n";
            key = "<C-e>";
            action = luaFn {
              module = "keymaps";
              function = "harpoon_toggle_quick_menu";
            };
            options.desc = "harpoon toggle quick menu";
          }
          {
            mode = "n";
            key = "<leader>a";
            action = luaFn {
              module = "keymaps";
              function = "harpoon_add_file";
            };
            options.desc = "harpoon add file";
          }
          {
            mode = "n";
            key = "<C-a>";
            action = luaFn {
              module = "keymaps";
              function = "harpoon_nav_file_1";
            };
            options.desc = "harpoon nav file 1";
          }
          {
            mode = "n";
            key = "<C-s>";
            action = luaFn {
              module = "keymaps";
              function = "harpoon_nav_file_2";
            };
            options.desc = "harpoon nav file 2";
          }
          {
            mode = "n";
            key = "<C-f>";
            action = luaFn {
              module = "keymaps";
              function = "harpoon_nav_file_3";
            };
            options.desc = "harpoon nav file 3";
          }
          {
            mode = "n";
            key = "<C-n>";
            action = luaFn {
              module = "keymaps";
              function = "harpoon_navigate_next";
            };
            options.desc = "harpoon navigate next";
          }
          {
            mode = "n";
            key = "<C-p>";
            action = luaFn {
              module = "keymaps";
              function = "harpoon_navigate_previous";
            };
            options.desc = "harpoon navigate previous";
          }

          # Tree, Zen mode, and theme actions.
          {
            mode = "n";
            key = "<leader>e";
            action = luaFn {
              module = "keymaps";
              function = "nvimtree_focus_open_nvimtree_closes_if_open";
            };
            options.desc = "nvimtree focus/open nvimtree (closes if open)";
          }
          {
            mode = "n";
            key = "<leader>zm";
            action = luaFn {
              module = "keymaps";
              function = "zenmode_toggle";
            };
            options.desc = "zenmode toggle";
          }
          {
            mode = "n";
            key = "<leader>ct";
            action = luaFn {
              module = "keymaps";
              function = "source_themes";
            };
            options.desc = "source themes";
          }
          {
            mode = "n";
            key = "<leader>tt";
            action = luaFn {
              module = "keymaps";
              function = "toggle_trasparency";
            };
            options.desc = "toggle trasparency";
          }

          # Local LSP, parser inspection, Trouble, and Markdown Preview actions.
          {
            mode = "n";
            key = "<leader>ll";
            action = "<cmd>LspRestart<CR>";
            options.desc = "restart lsp";
          }
          {
            mode = "n";
            key = "<leader>ca";
            action = luaFn {
              module = "keymaps";
              function = "code_action";
            };
            options.desc = "code action";
          }
          {
            mode = "n";
            key = "S";
            action = luaFn {
              module = "keymaps";
              function = "diagnostic_float";
            };
            options.desc = "diagnostic float";
          }
          {
            mode = "n";
            key = "gr";
            action = luaFn {
              module = "keymaps";
              function = "references";
            };
            options.desc = "references";
          }
          {
            mode = "n";
            key = "gd";
            action = luaFn {
              module = "keymaps";
              function = "definition";
            };
            options.desc = "definition";
          }
          {
            mode = "n";
            key = "gi";
            action = luaFn {
              module = "keymaps";
              function = "implementation";
            };
            options.desc = "implementation";
          }
          {
            mode = "n";
            key = "<leader>D";
            action = luaFn {
              module = "keymaps";
              function = "type_definition";
            };
            options.desc = "type definition";
          }
          {
            mode = "n";
            key = "<leader>it";
            action = "<cmd>InspectTree<CR>";
            options.desc = "inspect tree";
          }
          {
            mode = "n";
            key = "<leader>ic";
            action = "<cmd>Inspect<CR>";
            options.desc = "inspect cursor";
          }
          {
            mode = "n";
            key = "<leader>te";
            action = luaFn {
              module = "keymaps";
              function = "trouble_errors";
            };
            options.desc = "trouble errors";
          }
          {
            mode = "n";
            key = "<leader>tw";
            action = "<cmd>Trouble todo<CR>";
            options.desc = "trouble TODOs";
          }
          {
            mode = "n";
            key = "<leader>td";
            action = luaFn {
              module = "keymaps";
              function = "trouble_diagnostics";
            };
            options.desc = "Trouble diagnostics";
          }
          {
            mode = "n";
            key = "<leader>ts";
            action = "<cmd>Trouble symbols toggle focus=false<CR>";
            options.desc = "trouble symbols";
          }
          {
            mode = "n";
            key = "<leader>mp";
            action = "<cmd>MarkdownPreview<CR>";
            options.desc = "MarkdownPreview";
          }

          # Git and Diffview. The command-line mappings intentionally await arguments/confirmation.
          {
            mode = "n";
            key = "<leader>gb";
            action = "<cmd>Gitsigns blame_line<CR>";
            options.desc = "Gitsigns blame_line";
          }
          {
            mode = "n";
            key = "<leader>gd";
            action = ":Gitsigns diffthis";
            options.desc = "Gitsigns diffthis";
          }
          {
            mode = "n";
            key = "<leader>gs";
            action = ":Gitsigns show";
            options.desc = "Gitsigns diffthis";
          }
          {
            mode = "n";
            key = "<leader>gn";
            action = "<cmd>Gitsigns setqflist<CR>";
            options.desc = "Gitsigns navigate changes";
          }
          {
            mode = "n";
            key = "<leader>rc";
            action = luaFn {
              module = "keymaps";
              function = "review_changes_diffview_toggle";
            };
            options.desc = "review changes (diffview toggle)";
          }
          {
            mode = "n";
            key = "<C-g>";
            action = ":Git ";
          }

          # vim-tmux-navigator wins over NvChad's window-navigation mappings.
          {
            mode = "n";
            key = "<C-h>";
            action = "<cmd>TmuxNavigateLeft<CR>";
            options.desc = "tmux navigate left";
          }
          {
            mode = "n";
            key = "<C-j>";
            action = "<cmd>TmuxNavigateDown<CR>";
            options.desc = "tmux navigate down";
          }
          {
            mode = "n";
            key = "<C-k>";
            action = "<cmd>TmuxNavigateUp<CR>";
            options.desc = "tmux navigate up";
          }
          {
            mode = "n";
            key = "<C-l>";
            action = "<cmd>TmuxNavigateRight<CR>";
            options.desc = "tmux navigate right";
          }

          # OpenCode plugin-spec mappings, kept callback-based so loading is action-driven.
          {
            mode = ["n" "t"];
            key = "<M-o>";
            action = luaFn {
              module = "keymaps";
              function = "toggle_opencode";
            };
            options.desc = "Toggle opencode";
          }
          {
            mode = ["n" "x"];
            key = "<leader>oa";
            action = luaFn {
              module = "keymaps";
              function = "ask_opencode";
            };
            options.desc = "Ask opencode";
          }
        ];
      };
    };
  };
}
