# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  ...
}: let
  monitors = {
    primary = "DP-3";
    secondary = "DP-2";
  };
  machineConfig = {
    name = "desktop";
    monitors = monitors;
    binds = [];
    extraEnv = [];
    bookmarks = [
      "file:///mnt/Shared"
      "file:///mnt/Shared/Videos/Vpapers"
      "file:///mnt/Backup"
    ];
  };
in {
  _module.args = {inherit machineConfig;};
  imports = [
    ./hardware-configuration.nix
    ./openrgb
    ./ai.nix
    ../configuration.nix
  ];
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
  };
  services.k3s = {
    package = pkgs.k3s_1_30;
    enable = true;
    role = "agent";
    token = "K10730cf4e30f81f7c38c2a0936d1bd5550cba0c33e5635f830fe59bad0530f327e::server:dab0ba8b99375e3aedb9f440acfb9b4e";
    serverAddr = "https://pi-master:6443";
  };
  services.xserver.screenSection = ''
    Option "metamodes" "${monitors.primary}: 3840x2160_144 +3840+0, ${monitors.secondary}: 3840x2160_144 +0+0"
  '';
  networking.hostName = "lurian-desktop";

  # bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  users.users.github-runner = {
    isNormalUser = true;
    extraGroups = ["docker"];
  };
  services.github-runners = {
    repricer = {
      enable = true;
      url = "https://github.com/Lur1an/repricer/";
      name = "repricer";
      user = "github-runner";
      tokenFile = "/home/lurian/.github-runner-pat";
      extraLabels = ["nix-phat"];
      extraPackages = with pkgs; [
        docker
        devenv
      ];
    };
  };
  # Make sure ollama is installed
  environment.systemPackages = with pkgs; [
    ollama
    open-webui
  ];
services.openiscsi = {
  enable = true;
  name = "${config.networking.hostName}-initiatorhost";
};

  # Define the systemd service
  systemd.services.ollama = {
    description = "Ollama Service";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"]; # Add dependency
    requires = ["network-online.target"]; # Add strict dependency

    serviceConfig = {
      Type = "simple";
      User = "lurian"; # Replace with your username
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "always";
      RestartSec = 3;
    };
  };
}
