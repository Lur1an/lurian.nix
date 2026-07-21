{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./foot.nix
    ./ghostty.nix
    ./kitty.nix
    ./zsh.nix
    ./tmux.nix
    ./treehouse.nix
    ./lazygit.nix
    ./pi-coding-agent.nix
    ./opencommit.nix
    ./opencode.nix
    ./zsh-ai.nix
  ];

  options.terminal = {
    code_font = lib.mkOption {
      type = lib.types.str;
      description = "Font to use in terminals";
    };

    opencode.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable opencode";
      default = false;
    };

    opencommit.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable opencommit";
      default = false;
    };

    foot = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable foot terminal";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.foot;
        description = "Foot package to use";
      };
    };

    ghostty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable ghostty terminal";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.ghostty;
        description = "Ghostty package to use";
      };
    };

    kitty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable kitty terminal";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.kitty;
        description = "Kitty package to use";
      };
    };
  };
}
