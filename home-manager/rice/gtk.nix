{pkgs, ...}: let
  font = {
    name = "Ubuntu Nerd Font";
    package = pkgs.nerd-fonts.ubuntu-mono;
    size = 11;
  };
  cursorTheme = {
    name = "Qogir";
    size = 24;
    package = pkgs.qogir-icon-theme;
  };
  iconTheme = {
    name = "Dracula";
    package = pkgs.dracula-icon-theme;
  };
in {
  home = {
    packages = with pkgs; [
      nerd-fonts.ubuntu
      font.package
      cursorTheme.package
      iconTheme.package
    ];
    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
    };
    pointerCursor =
      cursorTheme
      // {
        gtk.enable = true;
      };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    inherit font cursorTheme iconTheme;
    enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk2";
  };
}
