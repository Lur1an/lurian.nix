# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  ...
}: let
  machineConfig = {
    monitors = {
      primary = "eDP-1";
    };
    binds = [
      ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];
  };
in {
  _module.args = {inherit machineConfig;};
  imports = [
    ./hardware-configuration.nix
    ../configuration.nix
  ];

  boot.kernelParams = ["psmouse.synaptics_intertouch=0"];

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;

    package = config.boot.kernelPackages.nvidiaPackages.latest;
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
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.libinput = {
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

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
