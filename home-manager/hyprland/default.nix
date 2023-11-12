
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
  home.file."Wallpapers".source = ../../wallpapers;

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;

    extraConfig = ''
      $mod = SUPER

      bind = $mod, Q, killactive
      bind = $mod, M, exit
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
  };

  home.packages = with pkgs; [
    networkmanagerapplet
  ];
}
