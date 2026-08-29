{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    xserver = {
      enable = true;
      displayManager.startx = {
        enable = true;
      };
    };
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland = {
      enable = true;
    };
  };

  # programs.hyprland registers xdg-desktop-portal-hyprland. Add GTK for
  # non-Hyprland portal APIs and force screen capture to the Hyprland backend.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["hyprland" "gtk"];
      hyprland = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["hyprland"];
        "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
      };
    };
  };

  environment = {
    variables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia"; # hardware acceleration
      __GL_VRR_ALLOWED = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      CLUTTER_BACKEND = "wayland";
      WLR_RENDERER = "vulkan";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XCURSOR_SIZE = "48";
      GDK_SCALE = "2";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  environment.systemPackages = with pkgs;
    [
      libnotify
      hyprlock
      xwayland
      meson
      wayland-protocols
      wayland-utils
      wl-clipboard
      wlroots
      totem
      gthumb
      ffmpegthumbnailer
    ]
    ++ lib.optionals config.home-manager.users.lurian.lurian.terminal.wal.enable [
      pywalfox-native
    ];
}
