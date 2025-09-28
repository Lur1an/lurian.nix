{pkgs, ...}: {
  imports = [
    ./discord.nix
    ./firefox
    ./minecraft.nix
    ./obs.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    slack
    vdhcoapp
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
