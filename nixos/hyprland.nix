{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  config = {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    programs.hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };

    xdg.portal.wlr.enable = true;

    environment = {
      variables = {
        GBM_BACKEND= "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME= "nvidia";
        LIBVA_DRIVER_NAME= "nvidia"; # hardware acceleration
        __GL_VRR_ALLOWED="1";
        WLR_NO_HARDWARE_CURSORS = "1";
        WLR_RENDERER_ALLOW_SOFTWARE = "1";
        CLUTTER_BACKEND = "wayland";
        WLR_RENDERER = "vulkan";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
      };
      sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
      };
    };

    environment.systemPackages = with pkgs; [
      # notification
      dunst
      libnotify
      # wallpaper
      swww
      # app-launcher
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xwayland
      meson
      wayland-protocols
      wayland-utils
      wl-clipboard
      wlroots
      mpvpaper
      mpv
    ];
  };
}
