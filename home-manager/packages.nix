{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    libreoffice-qt
    networkmanagerapplet
    gnome-disk-utility
    gnome.gnome-bluetooth
    ffmpeg
    nix-index
    pavucontrol
  ];
}
