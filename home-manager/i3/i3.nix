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

    package = pkgs.i3-gaps;

    config = {
      modifier = mod;

      fonts = {
        names = [ "ComicCodeLigatures Nerd Font" ];
        size = 16.0;
      };

      gaps = {
        inner = 10;
        # smartGaps = true;
        smartBorders = "on";
      };
      terminal = "alacritty";

      startup = [
        # { command = "systemctl --user restart polybar"; always = true; notification = false; }
      ];

      defaultWorkspace = "workspace number 1";

      keybindings = lib.mkOptionDefault {
        "${mod}+T" = "exec alacritty";
      };

      window.border = 1; # 新規作成した window にのみ有効

      workspaceOutputAssign = [{ output = "eDP-1-1"; workspace = "10"; }];
    };
  };

  programs.rofi = {
    enable = true;
  };
}
