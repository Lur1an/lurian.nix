
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
  home.file."./config/hypr/start.sh".source = ./start.sh;
  home.file."Wallpapers".source = ./Wallpapers;

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = bash ~/.config/hypr/start.sh
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
    networkmanagerapplet
  ];
}
