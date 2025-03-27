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
          "workspace 3 silent, class:^(vesktop)"
          "workspace 3 silent, class:^(Slack)"
          "workspace 3 silent, class:^(org.telegram.desktop)"
          "workspace 2 silent, class:^(firefox)"
          "workspace 8 silent, class:camoufox-default"
          "workspace 8 silent, class:^(chromium)"
          "workspace 8 silent, class:^(google-chrome)"
        ];
    };
  };
}
