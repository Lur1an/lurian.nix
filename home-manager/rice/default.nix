{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./ags.nix
  ];

  home.packages = with pkgs; [
    loupe
  ];
}
