{pkgs, ...}: {
  imports = [
    ./discord.nix
    ./firefox
    ./minecraft.nix
    ./obs.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    protonvpn-gui
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
