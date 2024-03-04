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
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      enable = true;
      displayManager = {
        defaultSession = "none+i3";
        lightdm.enable = true;
      };
    };
  };
}
