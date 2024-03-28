{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # services.udev.extraRules = import ./rules.nix;
  boot.kernelModules = ["i2c-dev" "i2c-piix4"];
  hardware.i2c.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins; # enable all plugins
  };
  environment.systemPackages = [ pkgs.i2c-tools ];
  users.groups.i2c.members = [ "lurian" ]; # create i2c group and add default user to it
}
