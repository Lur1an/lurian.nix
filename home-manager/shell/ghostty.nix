{pkgs, custom, ...}: {
  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    settings = {
      font-size = 12;
      font-family = custom.code_font;
      theme = "/home/lurian/.cache/wal/colors-ghostty";
      clipboard-paste-protection = false;
    };
  };
}
