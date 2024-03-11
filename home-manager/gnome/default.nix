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
    gnomeExtensions.pop-shell
    gnomeExtensions.user-themes
    gnomeExtensions.unite
    gnomeExtensions.sound-output-device-chooser
  ];
}
