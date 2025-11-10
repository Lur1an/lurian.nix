{
  config,
  lib,
  ...
}: let
  cfg = config.terminal;
in {
  config = lib.mkIf (builtins.elem "foot" cfg.flavours) {
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
          font = "${cfg.code_font}:size=12";
          pad = "10x5 center";
          term = "screen-256color";
          include = "${config.home.homeDirectory}/.cache/wal/colors-foot.ini";
        };
        tweak = {
          sixel = "yes";
        };
      };
    };
  };
}
