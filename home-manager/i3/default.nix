{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  mod = "Mod4";
in {
  imports = [
    ./rofi.nix
  ];
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        uiColor = "#FFFFFF";
        showHelp = false;
      };
    };
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      bars = [];

      window = {
        border = 0;
        hideEdgeBorders = "both";
      };
      gaps = {
        inner = 10;
        outer = 5;
      };

      modifier = mod;

      keybindings = {
        "${mod}+t" = "exec alacritty";
        "${mod}+b" = "exec firefox";
        "${mod}+s" = "exec rofi -show drun -show-icons";
        "${mod}+f" = "exec nautilus";
        "${mod}+p" = "exec ${pkgs.flameshot}/bin/flameshot gui -c";
        "${mod}+q" = "kill";
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+r" = "mode resize";
      };

      modes = {
        resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "j" = "resize grow height 10 px or 10 ppt";
          "k" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };
    };
  };

  home.packages = with pkgs; [
    xclip
    dunst
    i3status
    i3lock
  ];
}
