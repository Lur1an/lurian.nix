{config, ...}: let
  colors = builtins.mapAttrs (name: value: builtins.replaceStrings ["#"] [""] value) config.colorscheme.colors;
  custom = {
    font = "ComicCodeLigatures Nerd Font";
    fontsize = "12";
    primary_accent = "cba6f7";
    background = "11111B";
    opacity = ".75";
  };
in {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "${custom.font}:size=${custom.fontsize}";
        pad = "10x5 center";
        dpi-aware = "no";
      };
      cursor = {
        color = "${custom.primary_accent} ${custom.primary_accent}";
        style = "beam";
      };
      colors = {
        alpha = "${custom.opacity}";
        foreground = colors.base05; # Text
        background = colors.base00; # Base
        regular0 = colors.base03; # Surface 1
        regular1 = colors.base08; # red
        regular2 = colors.base0A; # green
        regular3 = "f9e2af"; # yellow
        regular4 = "89b4fa"; # blue
        regular5 = "f5c2e7"; # pink
        regular6 = "94e2d5"; # teal
        regular7 = "bac2de"; # Subtext 1
        bright0 = "585b70"; # Surface 2
        bright1 = "f38ba8"; # red
        bright2 = "a6e3a1"; # green
        bright3 = "f9e2af"; # yellow
        bright4 = "89b4fa"; # blue
        bright5 = "f5c2e7"; # pink
        bright6 = "94e2d5"; # teal
        bright7 = "a6adc8"; # Subtext 0
      };
      tweak = {
        sixel = "yes";
      };
    };
  };
}
