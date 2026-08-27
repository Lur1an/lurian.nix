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
  nixvimPackages = pkgs.lib.recurseIntoAttrs (import ./nixvim {inherit (pkgs) callPackage;});
in {
  lurianFonts = pkgs.stdenv.mkDerivation {
    name = "lurianFonts";
    src = ../dotfiles/fonts;
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/share/fonts
      cp -r $src/* $out/share/fonts
    '';
  };

  omp-undo-redo = pkgs.callPackage ./omp-undo-redo.nix {};
  opencode = pkgs.callPackage ./opencode.nix {};
  inherit vulpineos;
  inherit nixvimPackages;
  vulpineos-image = pkgs.callPackage ./vulpine/image.nix {inherit vulpineos;};

  hyprwinwrap = pkgs.callPackage "${inputs.hyprwinwrap}/default.nix" {
    inherit hyprland hyprlandPlugins;
  };
}
