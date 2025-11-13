{...}: let
  mod = "alt";
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
        "${mod}-q" = "close";
        "${mod}-m" = "quit";
        
        "${mod}-f" = "exec-and-forget open -a Finder";
        "${mod}-t" = "exec-and-forget open -a Ghostty";
        "${mod}-s" = "exec-and-forget open -a Raycast";

        "${mod}-h" = "focus left";
        "${mod}-l" = "focus right";
        "${mod}-k" = "focus up";
        "${mod}-j" = "focus down";

        "${mod}-shift-h" = "move left";
        "${mod}-shift-l" = "move right";
        "${mod}-shift-k" = "move up";
        "${mod}-shift-j" = "move down";

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

        "${mod}-shift-1" = "move-node-to-workspace 1";
        "${mod}-shift-2" = "move-node-to-workspace 2";
        "${mod}-shift-3" = "move-node-to-workspace 3";
        "${mod}-shift-4" = "move-node-to-workspace 4";
        "${mod}-shift-5" = "move-node-to-workspace 5";
        "${mod}-shift-6" = "move-node-to-workspace 6";
        "${mod}-shift-7" = "move-node-to-workspace 7";
        "${mod}-shift-8" = "move-node-to-workspace 8";
        "${mod}-shift-9" = "move-node-to-workspace 9";
        "${mod}-shift-0" = "move-node-to-workspace 10";

        "${mod}-i" = "layout floating tiling";

        "${mod}-r" = "mode resize";
      };

      mode.resize.binding = {
        "h" = "resize width -50";
        "l" = "resize width +50";
        "k" = "resize height -50";
        "j" = "resize height +50";
        
        "escape" = "mode main";
        "${mod}-r" = "mode main";
      };

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      
      key-mapping.preset = "qwerty";
    };
  };
}
