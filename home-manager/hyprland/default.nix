{pkgs, ...}: {
  imports = [
    ./rofi.nix
    ./hypr
    ./ags.nix
    ./foot.nix
    ./fuzzel.nix
  ];
  home.packages = with pkgs; [];
}
