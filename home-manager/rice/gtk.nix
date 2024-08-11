{pkgs, ...}: let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "Ubuntu"
      "UbuntuMono"
      "CascadiaCode"
      "FantasqueSansMono"
      "FiraCode"
      "Mononoki"
    ];
  };
  theme = {
    name = "catppuccin-mocha-blue-compact+default";
    package =
      (pkgs.catppuccin-gtk.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "gtk";
          rev = "v1.0.3";
          fetchSubmodules = true;
          hash = "sha256-q5/VcFsm3vNEw55zq/vcM11eo456SYE5TQA3g2VQjGc=";
        };

        postUnpack = "";
      })
      .override
      {
        accents = ["blue"];
        variant = "mocha";
        size = "compact";
      };
  };
  font = {
    name = "Ubuntu Nerd Font";
    package = nerdfonts;
    size = 11;
  };
  cursorTheme = {
    name = "Qogir";
    size = 24;
    package = pkgs.qogir-icon-theme;
  };
  iconTheme = {
    package = pkgs.catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "blue";
    };
    name = "Papirus-Dark";
  };
in {
  home = {
    packages = with pkgs; [
      cantarell-fonts
      font-awesome
      theme.package
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
    file = {
      ".config/gtk-4.0/gtk.css".text = ''
        window.messagedialog .response-area > button,
        window.dialog.message .dialog-action-area > button,
        .background.csd{
          border-radius: 0;
        }
      '';
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    inherit font cursorTheme iconTheme;
    theme.name = theme.name;
    enable = true;
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      extraCss = ''
        headerbar, .titlebar,
        .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
          border-radius: 0;
        }
      '';
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };
}
