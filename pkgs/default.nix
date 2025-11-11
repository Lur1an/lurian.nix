# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: {
  lurianFonts = pkgs.stdenv.mkDerivation {
    name = "lurianFonts";
    src = ../dotfiles/fonts;
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/share/fonts
      cp -r $src/* $out/share/fonts
    '';
  };
}
