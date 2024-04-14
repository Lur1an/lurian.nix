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
    primary = "DP-3";
    secondary = "DP-2";
  };
  machineConfig = {
    monitors = monitors;
    binds = [];
  };
in {
  _module.args = {inherit machineConfig;};
  imports = [
    ./hardware-configuration.nix
    ./openrgb
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
  services.xserver.screenSection = ''
    Option "metamodes" "${monitors.primary}: 3840x2160_144 +3840+0, ${monitors.secondary}: 3840x2160_144 +0+0"
  '';
  networking.hostName = "lurian-desktop";
}
