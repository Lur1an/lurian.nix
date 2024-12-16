{custom, ...}: let
in {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      colors = {
        alpha = ".85";
        background = "000000";
      };
      cursor = {
        style = "beam";
      };
      main = {
        font = "${custom.code_font}:size=12";
        pad = "10x5 center";
        # term = "xterm-256color";
        term = "screen-256color";
      };
      tweak = {
        sixel = "yes";
      };
    };
  };
}
