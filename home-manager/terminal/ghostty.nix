{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal;
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
      };
      # Remap Command to Control for all keys on macOS
      keybindings = lib.mkIf pkgs.stdenv.isDarwin {
        # Basic Command -> Control mappings
        "cmd+a" = "ctrl+a";
        "cmd+b" = "ctrl+b";
        "cmd+c" = "ctrl+c";
        "cmd+d" = "ctrl+d";
        "cmd+e" = "ctrl+e";
        "cmd+f" = "ctrl+f";
        "cmd+g" = "ctrl+g";
        "cmd+h" = "ctrl+h";
        "cmd+i" = "ctrl+i";
        "cmd+j" = "ctrl+j";
        "cmd+k" = "ctrl+k";
        "cmd+l" = "ctrl+l";
        "cmd+m" = "ctrl+m";
        "cmd+n" = "ctrl+n";
        "cmd+o" = "ctrl+o";
        "cmd+p" = "ctrl+p";
        "cmd+q" = "ctrl+q";
        "cmd+r" = "ctrl+r";
        "cmd+s" = "ctrl+s";
        "cmd+t" = "ctrl+t";
        "cmd+u" = "ctrl+u";
        "cmd+v" = "ctrl+v";
        "cmd+w" = "ctrl+w";
        "cmd+x" = "ctrl+x";
        "cmd+y" = "ctrl+y";
        "cmd+z" = "ctrl+z";
        
        # Command+Shift combinations
        "cmd+shift+a" = "ctrl+shift+a";
        "cmd+shift+b" = "ctrl+shift+b";
        "cmd+shift+c" = "ctrl+shift+c";
        "cmd+shift+d" = "ctrl+shift+d";
        "cmd+shift+e" = "ctrl+shift+e";
        "cmd+shift+f" = "ctrl+shift+f";
        "cmd+shift+g" = "ctrl+shift+g";
        "cmd+shift+h" = "ctrl+shift+h";
        "cmd+shift+i" = "ctrl+shift+i";
        "cmd+shift+j" = "ctrl+shift+j";
        "cmd+shift+k" = "ctrl+shift+k";
        "cmd+shift+l" = "ctrl+shift+l";
        "cmd+shift+m" = "ctrl+shift+m";
        "cmd+shift+n" = "ctrl+shift+n";
        "cmd+shift+o" = "ctrl+shift+o";
        "cmd+shift+p" = "ctrl+shift+p";  # This will make paste work
        "cmd+shift+q" = "ctrl+shift+q";
        "cmd+shift+r" = "ctrl+shift+r";
        "cmd+shift+s" = "ctrl+shift+s";
        "cmd+shift+t" = "ctrl+shift+t";
        "cmd+shift+u" = "ctrl+shift+u";
        "cmd+shift+v" = "ctrl+shift+v";
        "cmd+shift+w" = "ctrl+shift+w";
        "cmd+shift+x" = "ctrl+shift+x";
        "cmd+shift+y" = "ctrl+shift+y";
        "cmd+shift+z" = "ctrl+shift+z";
      };
    };
  };
}
