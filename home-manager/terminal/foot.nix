{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.terminal;
in {
  options.lurian.terminal.foot = {
    enable = lib.mkEnableOption "Foot terminal";
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.foot;
      description = "Foot package to use";
    };
  };
  config = lib.mkIf cfg.foot.enable {
    lurian.terminal.wal.templates = lib.mkIf cfg.wal.enable {
      "colors-foot.ini" = ./foot-wal.ini;
    };
    programs.foot = {
      enable = true;
      package = cfg.foot.package;
      server.enable = true;
      settings = {
        colors = {
          alpha = ".85";
          background = "000000";
        };
        cursor.style = "beam";
        main =
          {
            font = "${cfg.codeFont}:size=12";
            pad = "10x5 center";
            term = "screen-256color";
          }
          // lib.optionalAttrs cfg.wal.enable {
            include = "${config.home.homeDirectory}/.cache/wal/colors-foot.ini";
          };
        tweak.sixel = "yes";
      };
    };
  };
}
