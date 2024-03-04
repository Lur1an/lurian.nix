{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./rofi.nix
    ./waybar
    ../themes
    ./hypr
    ./foot.nix
  ];
  home.packages = with pkgs; [
  ];
}
