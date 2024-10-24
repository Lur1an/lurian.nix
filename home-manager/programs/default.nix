{pkgs, ...}: {
  imports = [
    ./discord.nix
    ./firefox.nix
    ./minecraft.nix
    ./obs.nix
    ./chrome.nix
  ];

  home.packages = with pkgs; [
    slack
    remmina
    appflowy
    telegram-desktop
    obsidian
    pywal
    spacedrive
    evince
    kdePackages.kolourpaint
    nautilus
    monero-gui
    monero-cli
  ];
}
