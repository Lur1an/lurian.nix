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
  machineConfig = {
    monitors = {
      primary = "DP-4";
      secondary = "DP-3";
    };
    binds = [];
  };
in {
  _module.args = {inherit machineConfig;};
  imports = [
    ./hardware-configuration.nix
    ./openrgb
    ../configuration.nix
  ];
  services.xserver.screenSection = ''
    Option "metamodes" "DP-2: 3840x2160_144 +3840+0, DP-4: 3840x2160_144 +0+0"
  '';
  networking.hostName = "lurian-desktop";
}
