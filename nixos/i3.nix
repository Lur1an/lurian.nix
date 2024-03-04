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
      defaultSession = "none+i3";
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      enable = true;
      displayManager.lightdm.enable = true;
    };
  };
}
