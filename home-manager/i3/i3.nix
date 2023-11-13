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
    shadow = true;
    shadowOffsets = [
      (-15)
      (-15)
    ];
    settings = {
      backend = "glx"; # Fixes black backdrop on some rounded corners
      corner-radius = 12;
      round-borders = 1;
      blur = {
        method = "gaussian";
        size = 8;
        deviation = 2;
      };
      blur-background-exclude = [
        "override_redirect = true"
      ];
      # Ignore polybar
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
      shadow-exclude = [
        "class_g = 'i3-frame'"
        "override_redirect = true"
      ];
      opacity-rule = [
        "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
    };
  };
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;

    package = pkgs.i3-gaps;

    config = {
      defaultWorkspace = "workspace number 1"; # defaults to 10 for some reason
      modifier = mod;
      terminal = "alacritty";
      gaps = {
        inner = 12;
        smartGaps = true;
      };

      keybindings = {
        "${mod}+T" = "exec alacritty";
        "${mod}+S" = "exec rofi -show drun";
        "${mod}+B" = "exec firefox";
        "${mod}+Ctrl+H" = "resize shrink width 16px or 1ppt";
        "${mod}+Ctrl+L" = "resize grow width 16px or 1ppt";
        "${mod}+Ctrl+K" = "resize grow height 16px or 1ppt";
        "${mod}+Ctrl+J" = "resize shrink height 16px or 1ppt";
        "${mod}+Q" = "kill";
      };
      window.commands = [
      {
        command = "border pixel 0";
        criteria = { class = "^.*"; };
      }
      ];
    };

  };

  programs.rofi = {
    enable = true;
  };
}
