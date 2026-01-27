# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{config, ...}: let
  machineConfig = {
    name = "desktop";
    bookmarks = [
      "file:///mnt/Shared"
      "file:///mnt/Shared/Videos/Vpapers"
      "file:///mnt/Backup"
      "file:///mnt/lurian-nfs"
    ];
  };
in {
  _module.args = {inherit machineConfig;};
  imports = [
    ./hardware-configuration.nix
    ./openrgb.nix
    ./k3s.nix
    ../../modules/ai.nix
    ../../modules/lurian.nix
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 13;
  };
  home-manager.users.lurian = import ../../home-manager/profiles/desktop.nix;

  boot.loader.efi.canTouchEfiVariables = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  fileSystems = {
    "/mnt/Shared" = {
      device = "/dev/disk/by-uuid/18F7DC4E717D1349";
      fsType = "ntfs";
    };
    "/mnt/Backup" = {
      device = "/dev/disk/by-uuid/14D66766762D4230";
      fsType = "ntfs";
    };
    "/mnt/Data" = {
      device = "/dev/disk/by-uuid/36EE2E315B2824D1";
      fsType = "ntfs";
    };
    "/mnt/lurian-nfs" = {
      device = "lurian-nas.local:/volume1/main";
      fsType = "nfs";
      options = ["nfsvers=3" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };
  };

  networking.hostName = "lurian-desktop";

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  system.stateVersion = "23.11";
}
