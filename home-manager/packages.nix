{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    libreoffice-qt
    networkmanagerapplet
    gnome-disk-utility
    ffmpeg
    nix-index
    pavucontrol
  ];
}
