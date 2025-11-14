{
  config,
  lib,
  ...
}: let
  cfg = config.terminal;
in {
  config = lib.mkIf cfg.foot.enable {
    programs.foot = {
      enable = true;
      package = cfg.foot.package;
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
