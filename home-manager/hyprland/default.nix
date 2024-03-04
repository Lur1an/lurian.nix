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
    ../themes
    ./hypr
    ./foot.nix
  ];
  home.packages = with pkgs; [
  ];
}
