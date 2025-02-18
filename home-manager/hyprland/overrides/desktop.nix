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
    };
  };
}
