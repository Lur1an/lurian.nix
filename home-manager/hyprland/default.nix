{
  inputs,
  machineConfig,
  pkgs,
  ...
}: let
  xwaylandbridge_patch = [
    "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "nofocus,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
  ];
in {
  home.packages = with pkgs; [
    slurp
    grim
  ];
  imports =
    if machineConfig.name == "zephyrus"
    then [
      ./overrides/zephyrus.nix
    ]
    else if machineConfig.name == "desktop"
    then [
      ./overrides/desktop.nix
    ]
    else if machineConfig.name == "xps15"
    then [
      ./overrides/xps15.nix
    ]
    else [];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = with inputs; [
      hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
    ];
    xwayland.enable = true;
    settings = {
      env = [
        "WLR_DRM_NO_ATOMIC,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "ELECTRON_ENABLE_WAYLAND,1"
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
      input = {
        kb_options = "caps:escape";
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          drag_lock = true;
        };
      };
      windowrulev2 =
        xwaylandbridge_patch
        ++ [
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "nofocus,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
        ];
      decoration = {
        shadow = {
          color = "rgba(00000044)";
          range = 8;
          render_power = 2;
        };
        dim_inactive = false;

        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          new_optimizations = false; # SET true if LAGGING
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          xray = true;
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
        use_cpu_buffer = true;
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
      bindm = ''
        ALT,mouse:272,movewindow
      '';
      wsbind = [];
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "asztal -b hypr"
        "hyprctl setcursor Qogir 24"
        "discord"
        "openrgb"
        "telegram-desktop"
        "firefox"
        "exec systemctl start polkit-gnome-authentication-agent-1"
        "pywalfox start"
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
    '';
  };
}
