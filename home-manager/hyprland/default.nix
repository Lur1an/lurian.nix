
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

  wayland.windowManager.hyprland.extraConfig = ''
      bind = $mod, B, exec, firefox

      bind = $mod, S, exec, rofi -show drun -show-icons
      bind = CTRL, T, exec, alacritty
  '';
  wayland.windowManager.hyprland.enable = true;
}
