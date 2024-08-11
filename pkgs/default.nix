# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? import <nixpkgs> {},
  inputs,
}: {
  hetzner-k3s = pkgs.callPackage ./hetzner-k3s {};
  asztal = pkgs.callPackage ../dotfiles/ags {inherit inputs;};
}
