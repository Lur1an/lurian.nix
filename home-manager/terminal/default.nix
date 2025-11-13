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

    flavours = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["foot" "ghostty" "kitty"]);
      default = [];
      description = "List of terminal emulators to enable";
    };
  };
}
