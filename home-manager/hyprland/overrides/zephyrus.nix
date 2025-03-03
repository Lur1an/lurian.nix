{...}: {
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        ",preferred,auto, 1.25"
      ];
      bind =
        import ../binds.nix
        ++ [
          # Zephyrus specific binds can be added here
          ",XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight set 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight set 10%-"
        ];
      windowrule =
        import ../windowrule.nix
        ++ [
          "opacity 0.9,^(vesktop)"
          "opacity 0.9, ^(org.telegram.desktop)"
          "opacity 0.9,^(Slack)"
          "workspace 3 silent, ^(vesktop)"
          "workspace 3 silent, ^(Slack)"
          "workspace 3 silent, ^(org.telegram.desktop)"
          "workspace 2 silent, ^(firefox)"
          "workspace 8 silent, camoufox-default"
          "workspace 8 silent, ^(chromium)"
          "workspace 8 silent, ^(google-chrome)"
        ];
    };
  };
}
