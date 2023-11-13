{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: 
let
  mod = "Mod4";
in
{
  services.picom = {
    enable = true;
  };
  xsession.enable = true;
  xsession.scriptPath = ".hm-xsession";
  xsession.windowManager.i3 = {
    enable = true;

    # package = pkgs.i3-gaps;

    config = {
      modifier = mod;
      terminal = "alacritty";

      keybindings = lib.mkOptionDefault {
        "${mod}+T" = "exec alacritty";
      };
    };
  };

  programs.rofi = {
    enable = true;
  };
}
