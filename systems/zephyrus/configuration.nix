{
  config,
  inputs,
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
    inputs.claude-api.nixosModules.default
    ../../modules/lurian.nix
  ];

  lurian.gaming.enable = true;

  services.tailscale.enable = true;

  services.claude-api = {
    user = "lurian";
    enable = true;
    environment = {
      CLAUDE_CONFIG_DIR = "/home/lurian/.claude";
      HOME = "/home/lurian";
      XDG_CACHE_HOME = "/home/lurian/.cache";
      UV_CACHE_DIR = "/home/lurian/.cache/uv";
    };
  };

  boot.kernelParams = ["i915U" "i915.enable_dpcd_backlight=3"];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = ["asus-armoury"];

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 13;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.videoDrivers = ["modesetting" "nvidia"];
  services.asusd = {
    enable = true;
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

  home-manager.users.lurian = import ../../home-manager/profiles/zephyrus.nix;
}
