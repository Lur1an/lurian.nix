# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: let
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hyprlandPlugins = pkgs.hyprlandPlugins.override {inherit hyprland;};
  vulpineos = pkgs.callPackage ./vulpine {};
in {
  opencode = pkgs.callPackage ./opencode.nix {};
  inherit vulpineos;
  vulpineos-image = pkgs.callPackage ./vulpine/image.nix {inherit vulpineos;};

  hyprwinwrap = pkgs.callPackage "${inputs.hyprwinwrap}/default.nix" {
    inherit hyprland hyprlandPlugins;
  };
}
