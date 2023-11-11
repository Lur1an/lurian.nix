
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
    # config
    bind = [
      "SUPER,Q,killactive"
      "SUPER,M,exit"
      "SUPER,B,exec,firefox"
      "SUPER,T,exec,kitty"
      "SUPER,S,exec,rofi -show drun -show-icons"
    ];
    decoration = {
      rounding = 5;
      blur = {
        enabled = false;
      };
    };
  };

  home.packages = with pkgs; [
    networkmanagerapplet
  ];
}
