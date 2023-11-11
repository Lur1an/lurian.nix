
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
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = ''
    $mod = SUPER

    bind = $mod, B, exec, firefox
    bind = CTRL, T, exec, alacritty
    bind = $mod, S, exec, rofi -show drun -show-icons
  '';
}
