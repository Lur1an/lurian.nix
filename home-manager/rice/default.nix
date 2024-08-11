{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./nix-colors
    ./ags.nix
  ];

  home.packages = with pkgs; [
    loupe
  ];
}
