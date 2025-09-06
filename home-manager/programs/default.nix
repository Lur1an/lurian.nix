{pkgs, ...}: {
  imports = [
    ./discord.nix
    ./firefox
    ./minecraft.nix
    ./obs.nix
    ./chrome.nix
  ];

  home.packages = with pkgs; [
    protonvpn-gui
    slack
    vdhcoapp
    remmina
    zoom-us
    spotify
    telegram-desktop
    obsidian
    wallust
    evince
    nautilus
  ];
}
