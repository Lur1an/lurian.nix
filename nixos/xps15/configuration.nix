# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../configuration.nix
  ];

  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.prime = {
      offload.enable = true;
      # Make sure to use the correct Bus ID values for your system!
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
  };

  services.xserver.libinput = {
    enable = true;
    touchpad = {
      sendEventsMode = "enabled";
      scrollMethod = "twofinger";
      naturalScrolling = true;
      tapping = true;
      clickMethod = "clickfinger";
    };
  };

  networking.hostName = "lurian-xps15";
}
