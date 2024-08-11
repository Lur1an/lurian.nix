{
  inputs,
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
    ]
    # No additional config needed on laptop
    else [",preferred,auto, 1"];
in {
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
    ];
    xwayland.enable = true;
    settings = {
      env = [
        "WLR_DRM_NO_ATOMIC,1"
      ];
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
      windowrule = import ./windowrule.nix;
      input = {
        kb_options = "caps:escape";
      };
      windowrulev2 =
        xwaylandbridge_patch
        ++ [
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "nofocus,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
        ];

      workspace =
        [
          "1,monitor:${monitors.primary}"
          "2,monitor:${monitors.primary}"
          "3,monitor:${monitors.primary}"
          "4,monitor:${monitors.primary}"
        ]
        ++ (
          if builtins.hasAttr "secondary" monitors
          then [
            "5,monitor:${monitors.secondary}"
            "6,monitor:${monitors.secondary}"
            "7,monitor:${monitors.secondary}"
            "8,monitor:${monitors.secondary}"
          ]
          else []
        );

      decoration = {
        drop_shadow = "yes";
        shadow_range = 8;
        shadow_render_power = 2;
        "col.shadow" = "rgba(00000044)";

        dim_inactive = false;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };
      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 0;
        layout = "dwindle";
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 1;
      };
      cursor = {
        no_hardware_cursors = true;
        allow_dumb_copy = true;
        inactive_timeout = 3;
      };
      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
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
        "ags -b hypr"
        "hyprctl setcursor Qogir 24"
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
