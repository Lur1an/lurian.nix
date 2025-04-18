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
      cantarell-fonts
      nerd-fonts.ubuntu
      cascadia-code
      nerd-fonts.fira-code
      nerd-fonts.mononoki
      gtk-engine-murrine
      font-awesome
      font.package
      cursorTheme.package
      iconTheme.package
      adwaita-icon-theme
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
  catppuccin.flavor = "mocha";
  catppuccin.gtk.enable = true;

  gtk = {
    inherit font cursorTheme iconTheme;
    enable = true;
    gtk4 = {
      extraCss = ''
        @import 'matugen.css';
        window.messagedialog .response-area > button,
        window.dialog.message .dialog-action-area > button,
        .background.csd{
          border-radius: 0;
        }
      '';
    };
    gtk3 = {
      extraCss = ''
        @import 'matugen.css';
        headerbar, .titlebar,
        .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
          border-radius: 0;
        }
      '';
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk2";
  };
}
