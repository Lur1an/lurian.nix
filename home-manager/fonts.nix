{pkgs, ...}: let
  myFonts = pkgs.stdenv.mkDerivation {
    name = "myFonts";
    src = ../dotfiles/fonts; # Replace with the path to your font files
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/share/fonts
      cp -r $src/* $out/share/fonts
    '';
  };
in {
  home.packages = with pkgs; [
    # Fonts
    go-font
    nerdfonts
    noto-fonts
    dejavu_fonts
    font-awesome
    maple-mono-NF
    liberation_ttf
    powerline-fonts
    cantarell-fonts
    source-code-pro
    fira-code-symbols
    powerline-symbols
    material-design-icons
    myFonts
  ];
}
