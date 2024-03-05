{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
  ];
  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.sound-output-device-chooser
  ];
}
