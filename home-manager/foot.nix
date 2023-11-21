{...}: let
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
        foreground="cdd6f4"; # Text
        background="1e1e2e"; # Base
        regular0="45475a";   # Surface 1
        regular1="f38ba8";  # red
        regular2="a6e3a1";  # green
        regular3="f9e2af";  # yellow
        regular4="89b4fa";  # blue
        regular5="f5c2e7";  # pink
        regular6="94e2d5";  # teal
        regular7="bac2de";  # Subtext 1
        bright0="585b70";   # Surface 2
        bright1="f38ba8";   # red
        bright2="a6e3a1";   # green
        bright3="f9e2af";   # yellow
        bright4="89b4fa";   # blue
        bright5="f5c2e7";   # pink
        bright6="94e2d5";   # teal
        bright7="a6adc8";   # Subtext 0
        # regular0 = "#1E1E2E"; # black
        # regular1 = "ff5555"; # red
        # regular2 = "afffd7"; # green
        # regular3 = "f1fa8c"; # yellow
        # regular4 = "87afff"; # blue
        # regular5 = "bd93f9"; # magenta
        # regular6 = "8be9fd"; # cyan
        # regular7 = "f8f8f2"; # white
        # bright0 = "2d5b69"; # bright black
        # bright1 = "ff665c"; # bright red
        # bright2 = "84c747"; # bright green
        # bright3 = "ebc13d"; # bright yellow
        # bright4 = "58a3ff"; # bright blue
        # bright5 = "ff84cd"; # bright magenta
        # bright6 = "53d6c7"; # bright cyan
        # bright7 = "cad8d9"; # bright white
      };
      tweak = {
        sixel = "yes";
      };
    };
  };
}
