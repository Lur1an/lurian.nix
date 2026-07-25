{lib, ...}: let
  primary = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009629";
  secondary = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009657";
  primaryWaybar = "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009629";
in {
  imports = [
    ./linux.nix
  ];

  programs.waybar.settings.mainBar.output = ["${primaryWaybar}"];

  # Big local model also available in aichat (`aichat -m ollama:qwen3.6:27b`)
  terminal.zshAi.extraModels = ["qwen3.6:27b"];

  tmuxConfig = {
    projectDirs = [
      "~/Projects"
      "/mnt/Data"
    ];
  };

  treehouseConfig = {
    enable = true;
    root = "/mnt/Data";
  };

  # With `"*" = 5`, waybar generates 5 persistent workspaces per monitor id.
  # The disabled Unknown-1 output still gets monitor id 2, spawning ghost
  # workspaces 11-15. Pin the exact list instead.
  programs.waybar.settings.mainBar."hyprland/workspaces".persistent-workspaces =
    lib.mkForce {"*" = [1 2 3 4 5 6 7 8 9 10];};

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
      misc.vrr = 3;
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
