{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal;
  alphabet = lib.stringToCharacters "abcdefghijklmnopqrstuvwxyz";

  basicBindings = map (letter: "cmd+${letter}=ctrl+${letter}") alphabet;
  shiftBindings = map (letter: "cmd+shift+${letter}=ctrl+shift+${letter}") alphabet;

  # Generate Command to Control keybind remappings for macOS
  generateCmdToCtrlBindings = basicBindings ++ shiftBindings;
in {
  config = lib.mkIf cfg.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = cfg.ghostty.package;
      installVimSyntax = cfg.ghostty.package != null;
      settings = {
        font-size = 12;
        font-family = cfg.code_font;
        theme = "${config.home.homeDirectory}/.cache/wal/ghostty.conf";
        clipboard-paste-protection = false;
        background-opacity = 0.88;
        window-inherit-working-directory = true;
        window-padding-x = 10;
        window-padding-y = 5;
        window-padding-balance = true;
        macos-option-as-alt = true;
        # Remap Command to Control for all keys on macOS
        keybind = lib.mkIf pkgs.stdenv.isDarwin generateCmdToCtrlBindings [];
      };
    };
  };
}
