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
    ./hypr
    ./foot.nix
  ];
  home.packages = with pkgs; [
  ];
}
