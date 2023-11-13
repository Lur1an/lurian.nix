
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
      bind = $mod, T, exec, foot
      bind = $mod, S, exec, rofi -show drun -show-icons

      decoration {
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
