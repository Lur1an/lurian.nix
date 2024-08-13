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
    telegram-desktop
    obsidian
    evince
    kdePackages.kolourpaint
    nautilus
  ];
}
