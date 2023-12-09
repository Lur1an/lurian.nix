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
in {
  _module.args = {inherit monitors;};
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
