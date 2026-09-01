{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  lspNames = [
    "docker_compose_language_service"
    "dockerls"
    "tailwindcss"
    "svelte"
    "lua_ls"
    "terraformls"
    "ts_ls"
    "just"
    "ruff"
    "nixd"
    "helm_ls"
    "marksman"
    "html"
    "basedpyright"
  ];
in {
  options.lurian.terminal = {
    codeFont = mkOption {
      type = types.str;
      description = "Font used by terminal programs";
    };
    agents_md_path = mkOption {
      type = types.path;
      description = "Consumer-provided AGENTS.md or RULES.md source";
    };
    skills = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Directory containing OpenCode skill directories";
    };
    fonts.enable = mkEnableOption "consumer-provided Lurian font package";
    neovim = {
      enable = mkEnableOption "Lurian Neovim configuration";
      neocord.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Discord Rich Presence";
      };
      markdownPreview.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable Markdown preview";
      };
      lsps = lib.genAttrs lspNames (name: {
        enable = mkEnableOption "${name} language server";
      });
    };
    wal = {
      enable = mkEnableOption "pywal terminal theming";
      templates = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Templates keyed by the exact filename pywal writes";
      };
      linkWal = mkOption {
        type = types.functionTo types.path;
        readOnly = true;
        description = "Create an out-of-store link to a generated pywal file";
      };
    };
    matugen = {
      enable = mkEnableOption "Matugen template rendering";
      templates = mkOption {
        default = {};
        type = types.attrsOf (types.submodule {
          options = {
            input_path = mkOption {type = types.str;};
            output_path = mkOption {type = types.str;};
          };
        });
        description = "Matugen template registry";
      };
    };
    ghostty = {
      enable = mkEnableOption "Ghostty";
      package = mkOption {
        type = types.nullOr types.package;
        default = pkgs.ghostty;
        description = "Ghostty package, or null to use an externally installed binary";
      };
    };
    tmux = {
      enable = mkEnableOption "tmux";
      projectDirs = mkOption {
        type = types.listOf types.str;
        default = ["~/"];
        description = "Directories searched by tmux-sessionizer";
      };
    };
    opencode.enable = mkEnableOption "OpenCode";
    treehouse = {
      enable = mkEnableOption "Treehouse";
      root = mkOption {
        type = types.str;
        default = "${config.home.homeDirectory}/.treehouse";
        description = "Absolute Treehouse root";
      };
      maxTrees = mkOption {
        type = types.ints.positive;
        default = 16;
        description = "Maximum number of Treehouse worktrees";
      };
    };
    zsh = {
      enable = mkEnableOption "Zsh";
      extraShellFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = "Shell fragments inserted after bundled functions";
      };
    };
    omp.enable = mkEnableOption "Oh My Pi";
    lazygit.enable = mkEnableOption "Lazygit";
  };
}
