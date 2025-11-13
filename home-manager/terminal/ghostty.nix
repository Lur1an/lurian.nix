{
  config,
  lib,
  ...
}: let
  cfg = config.terminal;
in {
  config = lib.mkIf (builtins.elem "ghostty" cfg.flavours) {
    programs.ghostty = {
      enable = true;
      installVimSyntax = true;
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
      };
    };
  };
}
