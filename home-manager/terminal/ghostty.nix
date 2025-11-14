{
  config,
  lib,
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
    };
  };
}
