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

      };

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      
      key-mapping.preset = "qwerty";
    };
  };
}
