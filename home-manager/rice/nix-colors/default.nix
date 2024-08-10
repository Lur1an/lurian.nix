{inputs, ...}: let
  catppuccin-mocha = (import ./palettes/catppuccin-mocha.nix).colorscheme;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
  ];
  colorscheme = catppuccin-mocha;
}
