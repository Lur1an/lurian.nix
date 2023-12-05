
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # services.udev.extraRules = import ./rules.nix;
  #
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [
    openrgb
  ];
}
