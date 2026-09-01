{
  config,
  lib,
  ...
}: let
  cfg = config.lurian.terminal;
in {
  config = lib.mkIf cfg.ghostty.enable {
    lurian.terminal.wal.templates = lib.mkIf cfg.wal.enable {
      "ghostty.conf" = ./wal.conf;
    };
    programs.ghostty = {
      enable = true;
      package = cfg.ghostty.package;
      installVimSyntax = cfg.ghostty.package != null;
      settings =
        {
          font-size = 12;
          font-family = cfg.codeFont;
          clipboard-paste-protection = false;
          confirm-close-surface = false;
          background-opacity = 0.88;
          window-inherit-working-directory = false;
          window-padding-x = 10;
          window-padding-y = 5;
          window-padding-balance = true;
        }
        // lib.optionalAttrs cfg.wal.enable {
          theme = "${config.home.homeDirectory}/.cache/wal/ghostty.conf";
        };
    };
  };
}
