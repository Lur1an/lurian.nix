{
  config,
  pkgs,
  ...
}: let
  machineConfig = {
    name = "zephyrus";
    bookmarks = [];
  };
in {
  _module.args = {inherit machineConfig;};
  imports = [
    ./hardware-configuration.nix
    ../configuration.nix
    # ../ai.nix
  ];

  boot.kernelParams = ["i915U"];
  boot.kernelPackages = pkgs.linuxPackages_6_12_hardened;

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
  services.supergfxd = {
    enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
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
    redshift
    asusctl
  ];

  system.stateVersion = "24.11";
}
