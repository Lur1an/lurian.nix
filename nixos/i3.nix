{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
  };
}
