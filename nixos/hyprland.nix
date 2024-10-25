{
  inputs,
  pkgs,
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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland = {
      enable = true;
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

  environment.systemPackages = with pkgs; [
    libnotify
    swww
    inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xwayland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    xwaylandvideobridge
    wlroots

    totem
    gthumb
    gnome-desktop
    ffmpegthumbnailer
    gnome-text-editor
    gnome-calendar
    gnome-boxes
    gnome-system-monitor
    gnome-control-center
    gnome-weather
    gnome-calculator
    gnome-clocks
  ];
}
