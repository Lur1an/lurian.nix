{pkgs, ...}: {
  imports = [
    ./rofi.nix
    ./waybar
    ./hypr
  ];
  home.packages = with pkgs; [
    slurp
    grim
  ];
}
