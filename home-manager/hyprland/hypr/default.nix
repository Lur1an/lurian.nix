{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  primary_accent = "cba6f7";
  secondary_accent = "89b4fa";
  tertiary_accent = "f5f5f5";
  tokyonight_blue = "8aadf4";
  oxocarbon_pink = "ff7eb6";
  oxocarbon_border = "393939";
  oxocarbon_background = "161616";
  background = "11111B";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    settings = {
      decoration = {
        rounding = 5;
        shadow_ignore_window = true;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgb(${oxocarbon_background})";
        "col.shadow_inactive" = "rgb(${background})";
        blur = {
          enabled = false;
        };
      };
      general = {
        gaps_in = 1;
        gaps_out = 2;
        border_size = 3;
        "col.active_border" = "rgb(${oxocarbon_border})";
        "col.inactive_border" = "rgba(${background}00)";
        layout = "dwindle";
        apply_sens_to_raw = 1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      };
      animations = {
        enabled = true;
        bezier = [
          "pace,0.46, 1, 0.29, 0.99"
          "overshot,0.13,0.99,0.29,1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
        ];
        animation = [
          "border, 1, 10, md3_decel"
        ];
      };
      monitor = [
        "DP-4, 3840x2160@144, 0x0, 1.50"
        "DP-3, 3840x2160@144, 2560x0, 1.50"
        ",preferred,auto,1"
      ];
      bind = import ./binds.nix;
      exec-once = [
        "exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprctl setcursor 'macOS-BigSur' 32"
        "dunst &"
        "swww kill"
        "swww nit"
        "waybar"
      ];
    };
  };
}
