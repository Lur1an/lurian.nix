# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  monitors = {
    primary = "eDP-1";
  };
in {
  _module.args = {inherit monitors;};
  imports = [
    ./hardware-configuration.nix
    ../configuration.nix
  ];

  boot.kernelParams = ["psmouse.synaptics_intertouch=0"];

  hardware.nvidia.prime = {
    offload.enable = true;
    # Make sure to use the correct Bus ID values for your system!
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
  # bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

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
