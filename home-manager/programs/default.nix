{pkgs, ...}: {
  imports = [
    ./firefox
    ./minecraft.nix
    ./obs.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    slack
    vdhcoapp
    discord
    betterdiscordctl
    signal-desktop
    remmina
    zoom-us
    spotify
    telegram-desktop
    obsidian
    loupe
    wallust
    evince
    nautilus
  ];
}
