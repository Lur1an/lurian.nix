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
  xwaylandbridge_patch = [
    "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "nofocus,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
  ];
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
        "opacity 0.9,^(discord)"
      ];

      windowrulev2 = xwaylandbridge_patch ++ [
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
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
        cursor_inactive_timeout = 3;
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
        name:2,monitor:DP-4
        name:3,monitor:DP-4
        name:4,monitor:DP-4

        name:5,monitor:DP-3
        name:6,monitor:DP-3
        name:7,monitor:DP-3
        name:8,monitor:DP-3
      ];
      wsbind = [];
      exec-once = [
        "exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprctl setcursor 'macOS-BigSur' 22"
        "dunst &"
        "swww img ~/wallpapers/winpuccin.jpg"
        "swww init"
        "waybar"
      ];
    };
    extraConfig = ''
        submap=resize
        binde=,L,resizeactive,15 0
        binde=,H,resizeactive,-15 0
        binde=,K,resizeactive,0 -15
        binde=,J,resizeactive,0 15

        bind=,escape,submap,reset 
        bind=SUPER,R,submap,reset

        # will reset the submap, meaning end the current one and return to the global one
        submap=reset

        # For tearing
        env = WLR_DRM_NO_ATOMIC,1
    '';
    
  };
}
