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
    ./aider.nix
    ./opencommit.nix
    ./opencode.nix
  ];
  config = {
    home.packages = with pkgs; [
      direnv
      nix-direnv
    ];
  };

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

    aider.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable aider";
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
