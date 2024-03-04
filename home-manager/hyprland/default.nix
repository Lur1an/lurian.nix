{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./waybar
    ./hypr
    ./foot.nix
  ];
  home.packages = with pkgs; [
  ];
}
