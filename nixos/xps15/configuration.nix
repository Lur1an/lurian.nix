# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  ...
}: let
  machineConfig = {
    name = "xps15";
  };
in {
  _module.args = {inherit machineConfig;};
  imports = [
    ./hardware-configuration.nix
    ../configuration.nix
  ];

  boot.kernelParams = ["psmouse.synaptics_intertouch=0"];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 13;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;

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

  networking.hostName = "lurian-xps15";

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
