{pkgs, ...}: {
  gtk = {
    enable = true;
    cursorTheme = {
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
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
      name = "Papirus-Dark";
      package = pkgs.papirus-folders;
    };

    gtk3.extraCss = ''
      headerbar, .titlebar,
      .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
        border-radius: 0;
      }
    '';
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };
}
