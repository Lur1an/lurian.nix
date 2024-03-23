{
  inputs,
  outputs,
  lib,
  config,
  machineConfig,
  pkgs,
  ...
}: let
  colors = config.colorscheme.palette;
  xwaylandbridge_patch = [
    "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "nofocus,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
  ];
  specificBinds = machineConfig.binds;
  monitors = machineConfig.monitors;
  monitor_config =
    if builtins.hasAttr "secondary" monitors
    then [
      # In case a secondary monitor is present, this means we're on Desktop PC
      # With 4k monitors, both at 144hz, fractional scale them
      "${monitors.primary}, 3840x2160@144, 0x0, 1.50"
      "${monitors.secondary}, 3840x2160@144, 2560x0, 1.50"
      ",preferred,auto,1"
    ]
    # No additional config needed on laptop
    else [",preferred,auto, 1"];
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # plugins = [
    #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
    # ];
    xwayland.enable = true;
    settings = {
      xwayland = {
        force_zero_scaling = true;
      };
      layerrule = [
        "blur, waybar"
        "blur, wofi"
        "ignorezero, wofi"
      ];

      plugin = {
        hyprwinwrap = {
          class = "mpv";
        };
      };

      windowrule = [
        "float,^(pavucontrol)"
        "opacity 0.9,^(discord)"
        "opacity 0.9,telegram*"
        "workspace 3 silent, ^(discord)"
        "workspace 3 silent, telegram*"
        "workspace 5 silent, ^(firefox)"
        "workspace 7 silent, ^(google-chrome)"
      ];
      input = {
        kb_options = "caps:escape";
      };
      windowrulev2 =
        xwaylandbridge_patch
        ++ [
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^jetbrains-(?!toolbox),floating:1,title:^win\d+$"
          "noanim,class:^(xwaylandvideobridge)$"
          "nofocus,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
        ];

      workspace =
        [
          "${monitors.primary}, 1"
          "${monitors.primary}, 2"
          "${monitors.primary}, 3"
          "${monitors.primary}, 4"
        ]
        ++ (
          if builtins.hasAttr "secondary" monitors
          then [
            "${monitors.secondary}, 5"
            "${monitors.secondary}, 6"
            "${monitors.secondary}, 7"
            "${monitors.secondary}, 8"
          ]
          else []
        );

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
      monitor = monitor_config;
      bindm = ''
        ALT,mouse:272,movewindow
      '';
      bind = import ./binds.nix ++ specificBinds;
      wsbind = [];
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprctl setcursor 'macOS-BigSur' 22"
        "dunst &"
        "swww init"
        "swww img ~/wallpapers/winpuccin.jpg"
        "waybar"
        "discord"
        "telegram-desktop"
        "firefox"
        "exec systemctl start polkit-gnome-authentication-agent-1"
        "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"
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
