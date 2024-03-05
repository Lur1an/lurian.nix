{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./dconf.nix
  ];
  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.sound-output-device-chooser
  ];
}
