{...}: {
  imports = [
    ./linux.nix
  ];
  hyprdesktop.extraBinds = [
    ",XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight set 10%+"
    ",XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight set 10%-"
  ];
  hyprdesktop.customWindowRules = [
    "workspace 3 silent, match:class ^(discord)$"
    "workspace 3 silent, match:class ^(Slack)$"
    "workspace 3 silent, match:class ^(org.telegram.desktop)$"
    "workspace 2 silent, match:class ^(firefox)$"
    "workspace 8 silent, match:class ^camoufox-default$"
    "workspace 8 silent, match:class ^(chromium-browser)$"
    "workspace 8 silent, match:class ^(google-chrome)$"
  ];
}
