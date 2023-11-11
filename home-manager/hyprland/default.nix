
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
    bind = $mod, T, exec, kitty
    bind = $mod, S, exec, rofi -show drun -show-icons

    decoration {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 5
        blur {
        enabled = false
      }
    }
  '';

  home.packages = with pkgs; [
  ];
}
