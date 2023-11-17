{
  inputs,
  outputs,
  lib,
  config,
  monitors,
  pkgs,
  ...
}: 
let
  colors = config.colorscheme.colors;
in 
{
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    settings = {
      layerrule = [
        "blur, waybar"
        "blur, wofi"
        "ignorezero, wofi"
      ];

      windowrule = [
        "float,^(pavucontrol)"
      ];

      decoration = {
        rounding = 10;
        shadow_ignore_window = true;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgb(${colors.base0E})";
        "col.shadow_inactive" = "rgb(${colors.base00})";
        blur = {
          enabled = false;
        };
      };
      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 0;
        layout = "dwindle";
      };
      animations = {
          enabled = true;
          bezier = [ 
            "easeinoutsine, 0.37, 0, 0.63, 1" 
            "linear, 0.0, 0.0, 1.0, 1.0"
          ];
          animation = [ 
              "windows,1,2,easeinoutsine,slide" 
              "border,1,10,default"
              "fade,1,1,default"
              "workspaces,1,2,easeinoutsine,slide"
          ];
      };
      monitor = [
        "${monitors.primary}, 3840x2160@144, 0x0, 1.50"
        "${monitors.secondary}, 3840x2160@144, 2560x0, 1.50"
        ",preferred,auto,1"
      ];
      bind = import ./binds.nix;
      workspace = [
        name:1,monitor:DP-4
        name:2,monitor:DP-3
      ];
      wsbind = [];
      exec-once = [
        "exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprctl setcursor 'macOS-BigSur' 22"
        "dunst &"
        "swww kill"
        "swww init"
        "waybar"
      ];
    };
  };
}
