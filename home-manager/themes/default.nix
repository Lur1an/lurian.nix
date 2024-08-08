{
  inputs,
  pkgs,
  ...
}: let
  moreWaita = pkgs.stdenv.mkDerivation {
    name = "MoreWaita";
    src = inputs.more-waita;
    installPhase = ''
      mkdir -p $out/share/icons
      mv * $out/share/icons
    '';
  };
  catppuccin-mocha = (import ./palettes/catppuccin-mocha.nix).colorscheme;
  catppuccin-macchiato = (import ./palettes/catppuccin-macchiato.nix).colorscheme;
  oxocarbon-dark = (import ./palettes/oxocarbon-dark.nix).colorscheme;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
  ];
  colorscheme = catppuccin-mocha;
  home.packages = with pkgs; [
    # themes
    adwaita-qt6
    adw-gtk3
    material-symbols
    moreWaita
    bibata-cursors
    # morewaita-icon-theme
    # papirus-icon-theme
    # qogir-icon-theme
    # whitesur-icon-theme
    # colloid-icon-theme
    # qogir-theme
    # yaru-theme
    # whitesur-gtk-theme
    # orchis-theme
  ];
}
