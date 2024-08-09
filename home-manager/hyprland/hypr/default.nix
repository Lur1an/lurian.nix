{
  inputs,
  config,
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
        "GTK_IM_MODULE, fcitx"
        "QT_IM_MODULE, fcitx"
        "XMODIFIERS, @im=fcitx"
        "QT_QPA_PLATFORM, wayland"
        "QT_QPA_PLATFORMTHEME, qt5ct"
        "QT_STYLE_OVERRIDE,kvantum"
        "WLR_NO_HARDWARE_CURSORS, 1"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      layerrule = [
        "xray 1, .*"
        "noanim, selection"
        "noanim, overview"
        "noanim, anyrun"
        "blur, swaylock"
        "blur, eww"
        "ignorealpha 0.8, eww"
        "noanim, noanim"
        "blur, noanim"
        "blur, gtk-layer-shell"
        "ignorezero, gtk-layer-shell"
        "blur, launcher"
        "ignorealpha 0.5, launcher"
        "blur, notifications"
        "ignorealpha 0.69, notifications"
        "blur, session"
        "noanim, sideright"
        "noanim, sideleft"
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
        "noblur,.*" # Disables blur for windows. Substantially improves performance.
        "pin, ^(showmethekey-gtk)$"
        "float,title:^(Open File)(.*)$"
        "float,title:^(Select a File)(.*)$"
        "float,title:^(Choose wallpaper)(.*)$"
        "float,title:^(Open Folder)(.*)$"
        "float,title:^(Save As)(.*)$"
        "float,title:^(Library)(.*)$ "
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
          "tile,class:(wpsoffice)" 
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
        rounding = 20;

        blur = {
          enabled = true;
          xray = true;
          special = false;
          new_optimizations = true;
          size = 5;
          passes = 4;
          brightness = 1;
          noise = 1.0e-2;
          contrast = 1;
        };
        # Shadow
        drop_shadow = false;
        shadow_ignore_window = true;
        shadow_range = 20;
        shadow_offset = "0 2";
        shadow_render_power = 2;
        "col.shadow" = "rgba(0000001A)";

        # Dim
        dim_inactive = false;
        dim_strength = 0.1;
        dim_special = 0;
      };

      general = {
        gaps_in = 4;
        gaps_out = 5;
        gaps_workspaces = 50;
        border_size = 1;
        layout = "dwindle";
        resize_on_border = true;
        "col.active_border" = "rgba(471868FF)";
        "col.inactive_border" = "rgba(4f4256CC)";
      };

      cursor = {
        no_hardware_cursors = true;
        allow_dumb_copy = true;
        inactive_timeout = 3;
      };

      animations = {
        enabled = true;
        bezier = [
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0.1, 1, 0, 1"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 2.5, md3_decel"
          # "workspaces, 1, 3.5, md3_decel, slide"
          "workspaces, 1, 7, fluent_decel, slide"
          # "workspaces, 1, 7, fluent_decel, slidefade 15%"
          # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      misc = {
        vfr = 1;
        vrr = 1;
        # layers_hog_mouse_focus = true;
        focus_on_activate = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        enable_swallow = false;
        swallow_regex = "(foot|kitty|allacritty|Alacritty)";

        disable_hyprland_logo = true;
        new_window_takes_over_fullscreen = 2;
      };

      monitor = monitor_config;

      bindm = ''
        ALT,mouse:272,movewindow
      '';

      bind = import ./binds.nix ++ specificBinds;

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprctl setcursor 'macOS-BigSur' 22"
        "swww kill; swww init"
        # "ags &"
        "fcitx5"
        "swww img ~/wallpapers/winpuccin.jpg"
        "discord"
        "telegram-desktop"
        "firefox"
        "exec systemctl start polkit-gnome-authentication-agent-1"
        "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"
      ];
      # source = [
      #   "./colors.conf"
      # ];
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
