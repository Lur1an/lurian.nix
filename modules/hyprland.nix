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
    hyprlock
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xwayland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    pywalfox-native
    totem
    gthumb
    ffmpegthumbnailer

    (pkgs.writeShellScriptBin "vpaper" ''
      if [ $# -lt 1 ]; then
        echo "Usage: vpaper <video-path> [matugen-type]"
        exit 1
      fi

      VIDEO_PATH="$1"
      MATUGEN_TYPE="''${2:-image}"
      WP="/tmp/wallpaper-frame.png"

      ${pkgs.ffmpeg}/bin/ffmpeg -i "$VIDEO_PATH" -vframes 1 -f image2 -y "$WP"

      ${pkgs.matugen}/bin/matugen -j hex "$MATUGEN_TYPE" "$WP"
      rm -rf /home/lurian/.cache/wal
      ${pkgs.pywal}/bin/wal -i "$WP" -n
      pywalfox update

      nohup ${pkgs.mpv}/bin/mpv --no-audio --panscan=1.0 --loop "$VIDEO_PATH" > /dev/null 2>&1 &
    '')
  ];
}
