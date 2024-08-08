{pkgs, ...}: {
  imports = [
    ./rofi.nix
    ./waybar
    ./hypr
    ./ags.nix
    ./foot.nix
  ];
  home.packages = with pkgs; [];
}
