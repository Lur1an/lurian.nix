{ config,
  pkgs,
  ...
}: let
  machineConfig = {
    extraEnv = [];
    name = "zephyrus";
    monitors = {
      primary = "eDP-1";
    };
    bookmarks = [];
    binds = [];
  };
in {
  _module.args = {inherit machineConfig;};
  imports = [
    ./hardware-configuration.nix
    ../configuration.nix
  ];

  boot.kernelParams = ["i915U"];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 13;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.videoDrivers = ["modesetting" "nvidia"];
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      # Make sure to use the correct Bus ID values for your system!
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };
  # bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

  services.libinput = {
    enable = true;
    touchpad = {
      sendEventsMode = "enabled";
      scrollMethod = "twofinger";
      naturalScrolling = false;
      tapping = true;
      clickMethod = "clickfinger";
    };
  };

  networking.hostName = "lurian-zephyrus";

  environment.systemPackages = with pkgs; [
    brightnessctl
    asusctl
  ];

  system.stateVersion = "24.11";
}
