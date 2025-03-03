{...}: let
  primary = "DP-4";
  secondary = "DP-3";
in {
  wayland.windowManager.hyprland = {
    settings = {
      workspace = [
        "1,monitor:${primary}"
        "2,monitor:${primary}"
        "3,monitor:${primary}"
        "4,monitor:${primary}"
        "5,monitor:${primary}"
        "6,monitor:${secondary}"
        "7,monitor:${secondary}"
        "8,monitor:${secondary}"
        "9,monitor:${secondary}"
        "10,monitor:${secondary}"
      ];
      monitor = [
        "${primary}, 3840x2160@144, 0x0, 1.50"
        "${secondary}, 3840x2160@144, 2560x0, 1.50"
        "Unknown-1,disabled"
      ];
      bind =
        import ../binds.nix
        ++ [
          # Desktop specific binds can be added here
        ];
      windowrule =
        import ../windowrule.nix
        ++ [
          "opacity 0.9,^(vesktop)"
          "opacity 0.9, ^(org.telegram.desktop)"
          "opacity 0.9,^(Slack)"
          "workspace 7 silent, ^(vesktop)"
          "workspace 7 silent, ^(Slack)"
          "workspace 7 silent, ^(org.telegram.desktop)"
          "workspace 6 silent, ^(firefox)"
          "workspace 8 silent, camoufox-default"
          "workspace 8 silent, ^(chromium)"
          "workspace 8 silent, ^(google-chrome)"
        ];
    };
  };
}
