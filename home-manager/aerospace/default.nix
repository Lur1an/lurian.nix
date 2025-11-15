{...}: let
  mod = "cmd";
in {
  programs.aerospace = {
    enable = true;
    
    launchd = {
      enable = true;
      keepAlive = true;
    };

    userSettings = {
      start-at-login = true;
      
      after-login-command = [];
      
      enable-normalization-flatten-containers = false;
      enable-normalization-opposite-orientation-for-nested-containers = false;
      
      accordion-padding = 30;
      
      gaps = {
        outer = {
          left = 3;
          bottom = 3;
          top = 3;
          right = 3;
        };
        inner = {
          horizontal = 3;
          vertical = 3;
        };
      };

      mode.main.binding = {
        "${mod}-h" = "focus --boundaries all-monitors-outer-frame --boundaries-action stop left";
        "${mod}-l" = "focus --boundaries all-monitors-outer-frame --boundaries-action stop right";
        "${mod}-k" = "focus --boundaries all-monitors-outer-frame --boundaries-action stop up";
        "${mod}-j" = "focus --boundaries all-monitors-outer-frame --boundaries-action stop down";

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

      };

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      
      key-mapping.preset = "qwerty";
    };
  };
}
