{ pkgs
, config
, inputs
, ...
}: {
  home.file.".config/hypr/hyprland.conf".source = ./config;
  # home.file.".wallpaper.jpg".source = ../../../wallpapers/current_wallpaper.jpg;

  home.packages = with pkgs; [
    # App launcher
    rofi-wayland-unwrapped

    # Network applet
    networkmanagerapplet

    # Screenshot / screen record
    kooha
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

    brightnessctl
    lxappearance

    xwaylandvideobridge

    # Audio visualizer
    cavalier
  ];
}
