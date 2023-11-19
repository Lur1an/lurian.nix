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
    ./themes
    ./hypr
  ];
  home.packages = with pkgs; [
  ];
}
