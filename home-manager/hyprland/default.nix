
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  wayland.windowManager.hyprland.enable = true;
}
