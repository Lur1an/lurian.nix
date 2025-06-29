{pkgs, ...}: {
  imports = [
    ./discord.nix
    ./firefox
    ./minecraft.nix
    ./obs.nix
    ./chrome.nix
  ];

  home.packages = with pkgs; [
    slack
    vdhcoapp
    remmina
    spotify
    appflowy
    telegram-desktop
    obsidian
    wallust
    spacedrive
    evince
    kdePackages.kolourpaint
    nautilus
    monero-gui
    monero-cli
  ];
}
