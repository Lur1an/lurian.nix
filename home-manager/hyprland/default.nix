{pkgs, ...}: {
  imports = [
    ./hypr
    ./ags.nix
    ./foot.nix
    ./fuzzel.nix
  ];
  home.packages = with pkgs; [];
}
