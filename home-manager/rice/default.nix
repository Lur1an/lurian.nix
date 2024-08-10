{ pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./nix-colors
  ];

  home.packages = with pkgs; [
  ];
}
