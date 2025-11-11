{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hyprdesktop;
in {
  options.hyprdesktop = {
    monitor = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Monitor configuration";
      default = [
        ",preferred,auto-right, 1.25"
      ];
    };
    extraBinds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Extra binds";
      default = [];
    };
    floatingWindows = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of floating windows";
      default = [];
    };
    windowRules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of window rules";
      default = [];
    };
  };
  imports = [
    ./windowrule.nix
    ./binds.nix
  ];
  config = {
    home.packages = with pkgs; [
      slurp
      grim
      mpv
    ];
    xdg.configFile."hypr/hyprland-extra.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/home-manager/hyprland/hyprland-extra.conf";
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      plugins = with inputs; [
        hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      ];
      xwayland.enable = true;
      settings = {
        monitor = cfg.monitor;
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
        cursor = {
          no_hardware_cursors = true;
          use_cpu_buffer = true;
          inactive_timeout = 3;
        };
        bindm = ''
          ALT,mouse:272,movewindow
        '';
        wsbind = [];
        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
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
        source = ~/.cache/matugen/hyprland-colors.conf
        source = ~/.config/hypr/hyprland-extra.conf

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
  };
}
