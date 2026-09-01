{
  config,
  lib,
  pkgs,
  ...
}: let
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
        enable = true;
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
  xdg.configFile = lib.mkIf config.lurian.terminal.matugen.enable {
    "matugen/templates/gtk3.css".source = ./matugen-gtk3.css;
    "matugen/templates/gtk4.css".source = ./matugen-gtk4.css;
  };
  lurian.terminal.matugen.templates = lib.mkIf config.lurian.terminal.matugen.enable {
    gtk3 = {
      input_path = "${config.xdg.configHome}/matugen/templates/gtk3.css";
      output_path = "${config.home.homeDirectory}/.config/gtk-3.0/gtk.css";
    };
    gtk4 = {
      input_path = "${config.xdg.configHome}/matugen/templates/gtk4.css";
      output_path = "${config.home.homeDirectory}/.config/gtk-4.0/gtk.css";
    };
  };
}
