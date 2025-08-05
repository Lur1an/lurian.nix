{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    libreoffice-qt
    networkmanagerapplet
    lsof
    gnome-disk-utility
    gnome-bluetooth
    ffmpeg
    nix-index
    pavucontrol
  ];
}
