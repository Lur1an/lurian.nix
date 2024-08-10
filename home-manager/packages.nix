{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    gthumb
    gnome-desktop
    ffmpegthumbnailer
    libreoffice-qt
    networkmanagerapplet
    gnome-disk-utility
    ffmpeg
    nix-index
    pavucontrol
  ];
}
