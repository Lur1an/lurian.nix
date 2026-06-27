# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: {
  lurianFonts = pkgs.stdenv.mkDerivation {
    name = "lurianFonts";
    src = ../dotfiles/fonts;
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/share/fonts
      cp -r $src/* $out/share/fonts
    '';
  };

  balena-etcher = pkgs.callPackage ./balena-etcher.nix {};
  opencode = pkgs.callPackage ./opencode.nix {};

  # Vendored hyprwinwrap (dropped from upstream hyprland-plugins flake).
  # Built against our Hyprland flake input so it matches the running compositor.
  hyprwinwrap = pkgs.callPackage ./hyprwinwrap {
    hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
}
