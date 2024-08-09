{
  inputs,
  pkgs,
  ...
}: let
  catppuccin-mocha = (import ./palettes/catppuccin-mocha.nix).colorscheme;
  catppuccin-macchiato = (import ./palettes/catppuccin-macchiato.nix).colorscheme;
  oxocarbon-dark = (import ./palettes/oxocarbon-dark.nix).colorscheme;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
  ];
  colorscheme = catppuccin-mocha;
  home.packages = with pkgs; [
    adwaita-qt6
    adw-gtk3
    material-symbols
    bibata-cursors
  ];
}
