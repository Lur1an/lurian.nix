{
  pkgs,
  custom,
  ...
}: {
  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    settings = {
      font-size = 12;
      font-family = custom.code_font;
      theme = "/home/lurian/.cache/wal/ghostty.conf";
      clipboard-paste-protection = false;
      background-opacity = 0.88;
      window-inherit-working-directory = true;
      # Add padding similar to foot's pad = "10x5 center";
      window-padding-x = 10;
      window-padding-y = 5;
      window-padding-balance = true;
    };
  };
}
