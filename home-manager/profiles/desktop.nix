{inputs, ...}: let
  primary = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009629";
  secondary = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009657";
  primaryWaybar = "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009629";
in {
  imports = [
    ./linux.nix
  ];

  programs.waybar.settings.mainBar.output = ["${primaryWaybar}"];

  hyprdesktop = {
    monitor = [
      "${primary}, 3840x2160@144, 0x0, 1.50"
      "${secondary}, 3840x2160@144, 2560x0, 1.50"
      "Unknown-1,disabled"
    ];
    customWindowRules = [
      "workspace 7 silent, match:class ^(vesktop)$"
      "workspace 7 silent, match:class ^(discord)$"
      "workspace 7 silent, match:class ^(Slack)$"
      "workspace 7 silent, match:class ^(org.telegram.desktop)$"
      "workspace 6 silent, match:class ^(firefox)$"
      "workspace 8 silent, match:class ^camoufox-default$"
      "workspace 8 silent, match:class ^(chromium)$"
      "workspace 8 silent, match:class ^(google-chrome)$"
      "workspace 9 silent, match:class ^(brave-browser)$"
    ];
  };
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
    };
  };
}
