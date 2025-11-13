{...}: {
  imports = [
    ./linux.nix
  ];
  hyprdesktop.extraBinds = [
    ",XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight set 10%+"
    ",XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight set 10%-"
  ];
  hyprdesktop.windowRules = [
    "workspace 3 silent, class:^(discord)"
    "workspace 3 silent, class:^(Slack)"
    "workspace 3 silent, class:^(org.telegram.desktop)"
    "workspace 2 silent, class:^(firefox)"
    "workspace 8 silent, class:camoufox-default"
    "workspace 8 silent, class:^(chromium-browser)"
    "workspace 8 silent, class:^(google-chrome)"
  ];
}
