{inputs, ...}: let
  catppuccin-mocha = (import ./palettes/catppuccin-mocha.nix).colorscheme;
  catppuccin-macchiato = (import ./palettes/catppuccin-macchiato.nix).colorscheme;
  oxocarbon-dark = (import ./palettes/oxocarbon-dark.nix).colorscheme;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
    ./gtk.nix
  ];
  colorscheme = catppuccin-mocha;
}
