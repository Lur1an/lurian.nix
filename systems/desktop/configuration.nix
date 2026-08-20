# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  ...
}: let
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
    ./qemu.nix
    ./treehouse.nix
    ../../modules/ai.nix
    ../../modules/lurian.nix
  ];

  lurian.gaming.enable = true;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 13;
  };
  home-manager.users.lurian = import ../../home-manager/profiles/desktop.nix;

  boot.loader.efi.canTouchEfiVariables = true;

  services.tailscale.enable = true;

  fileSystems = {
    "/mnt/Shared" = {
      device = "/dev/disk/by-uuid/18F7DC4E717D1349";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100"];
    };
    "/mnt/Backup" = {
      device = "/dev/disk/by-uuid/14D66766762D4230";
      fsType = "ntfs";
    };
    "/mnt/Data" = {
      device = "/dev/disk/by-uuid/36EE2E315B2824D1";
      fsType = "ntfs";
      options = ["uid=1000" "gid=100"];
    };
    "/mnt/lurian-nfs" = {
      device = "lurian-nas.local:/volume1/main";
      fsType = "nfs";
      options = ["nfsvers=3" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  networking.hostName = "lurian-desktop";

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  system.stateVersion = "23.11";
  environment.systemPackages = with pkgs; [
    android-tools
    balena-etcher
    qmd
  ];
}
