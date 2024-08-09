# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}}: {
  hetzner-k3s = pkgs.callPackage ./hetzner-k3s {};
  illogical-icons = pkgs.callPackage ./illogical-icons {};
}
