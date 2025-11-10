{pkgs, ...}: {
  home.packages = with pkgs; [
    go-font
    noto-fonts
    dejavu_fonts
    font-awesome
    maple-mono.NF
    liberation_ttf
    powerline-fonts
    cantarell-fonts
    source-code-pro
    fira-code-symbols
    powerline-symbols
    material-design-icons
    lurianFonts
  ];
}
