{
  pkgs,
  inputs,
  ...
}: let
  cursor-theme = "Bibata-Modern-Classic";
  cursor-package = pkgs.bibata-cursors;
  moreWaita = pkgs.stdenv.mkDerivation {
    name = "MoreWaita";
    src = inputs.more-waita;
    installPhase = ''
      mkdir -p $out/share/icons
      mv * $out/share/icons
    '';
  };
in {
  home.packages = [
    moreWaita
  ];

  home.file = {
    ".local/share/icons/MoreWaita" = {
      source = "${moreWaita}/share/icons";
    };
  };

  home.pointerCursor = {
    package = cursor-package;
    name = cursor-theme;
    size = 24;
    gtk.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = cursor-theme;
    XCURSOR_SIZE = "24";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = cursor-theme;
      package = cursor-package;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    theme = {
      name = "adw-gtk3-dark";
    };

    iconTheme = {
      name = moreWaita.name;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };
}
