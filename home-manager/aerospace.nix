{...}: let
  mod = "shift-alt";
  mod-move = "shift-alt-cmd";
in {
  programs.aerospace = {
    enable = true;
    
    launchd = {
      enable = true;
      keepAlive = true;
    };

    userSettings = {
      gaps = {
        outer = {
          left = 8;
          bottom = 8;
          top = 8;
          right = 8;
        };
        inner = {
          horizontal = 8;
          vertical = 8;
        };
      };

      mode.main.binding = {
        "${mod}-m" = "quit";
        
        "${mod}-f" = "exec-and-forget open -a Finder";
        "${mod}-t" = "exec-and-forget open -a Ghostty";
        "${mod}-s" = "exec-and-forget open -a Raycast";

        "${mod}-h" = "focus left";
        "${mod}-l" = "focus right";
        "${mod}-k" = "focus up";
        "${mod}-j" = "focus down";

        "${mod-move}-h" = "move left";
        "${mod-move}-l" = "move right";
        "${mod-move}-k" = "move up";
        "${mod-move}-j" = "move down";

        "${mod}-1" = "workspace 1";
        "${mod}-2" = "workspace 2";
        "${mod}-3" = "workspace 3";
        "${mod}-4" = "workspace 4";
        "${mod}-5" = "workspace 5";
        "${mod}-6" = "workspace 6";
        "${mod}-7" = "workspace 7";
        "${mod}-8" = "workspace 8";
        "${mod}-9" = "workspace 9";
        "${mod}-0" = "workspace 10";

        "${mod-move}-1" = "move-node-to-workspace 1";
        "${mod-move}-2" = "move-node-to-workspace 2";
        "${mod-move}-3" = "move-node-to-workspace 3";
        "${mod-move}-4" = "move-node-to-workspace 4";
        "${mod-move}-5" = "move-node-to-workspace 5";
        "${mod-move}-6" = "move-node-to-workspace 6";
        "${mod-move}-7" = "move-node-to-workspace 7";
        "${mod-move}-8" = "move-node-to-workspace 8";
        "${mod-move}-9" = "move-node-to-workspace 9";
        "${mod-move}-0" = "move-node-to-workspace 10";

        "${mod}-i" = "layout floating tiling";

        "${mod}-r" = "mode resize";
      };

      mode.resize.binding = {
        "h" = "resize width -50";
        "l" = "resize width +50";
        "k" = "resize height -50";
        "j" = "resize height +50";
        
        "esc" = "mode main";
        "${mod}-r" = "mode main";
      };

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      
      key-mapping.preset = "qwerty";
    };
  };
}
