{
  config,
  lib,
  pkgs,
  ...
}: let
  primary = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009629";
  secondary = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009657";
  primaryWaybar = "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009629";
  noOpen = pkgs.writeShellScriptBin "xdg-open" "exit 0";
  opencodeWeb = pkgs.writeShellScript "opencode-web" ''
    export PATH=${lib.makeBinPath ([noOpen config.programs.opencode.package] ++ config.programs.opencode.extraPackages)}
    exec opencode web --port 4098 --hostname 0.0.0.0
  '';
in {
  imports = [
    ./linux.nix
  ];

  programs.waybar.settings.mainBar.output = ["${primaryWaybar}"];

  # Big local model also available in aichat (`aichat -m ollama:qwen3.6:27b`)
  terminal.zshAi.extraModels = ["qwen3.8:27b"];

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

  systemd.user.services.opencode-web = {
    Unit = {
      Description = "OpenCode Web Service";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
    };

    Service = {
      ExecStart = opencodeWeb;
      WorkingDirectory = config.home.homeDirectory;
      Restart = "always";
      RestartSec = 5;
    };

    Install.WantedBy = ["default.target"];
  };

  # With `"*" = 5`, waybar generates 5 persistent workspaces per monitor id.
  # The disabled Unknown-1 output still gets monitor id 2, spawning ghost
  # workspaces 11-15. Pin the exact list instead.
  programs.waybar.settings.mainBar."hyprland/workspaces".persistent-workspaces =
    lib.mkForce {"*" = [1 2 3 4 5 6 7 8 9 10];};

  hyprdesktop = {
    monitor = [
      {
        output = primary;
        mode = "3840x2160@144";
        position = "0x0";
        scale = 1.5;
      }
      {
        output = secondary;
        mode = "3840x2160@144";
        position = "2560x0";
        scale = 1.5;
      }
      {
        output = "Unknown-1";
        disabled = true;
      }
    ];
    customWindowRules = [
      {
        class = "^(vesktop)$";
        workspace = "7";
      }
      {
        class = "^(discord)$";
        workspace = "7";
      }
      {
        class = "^(Slack)$";
        workspace = "7";
      }
      {
        class = "^(org.telegram.desktop)$";
        workspace = "7";
      }
      {
        class = "^(firefox)$";
        workspace = "6";
      }
      {
        class = "^camoufox-default$";
        workspace = "8";
      }
      {
        class = "^(chromium)$";
        workspace = "8";
      }
      {
        class = "^(google-chrome)$";
        workspace = "8";
      }
      {
        class = "^(brave-browser)$";
        workspace = "9";
      }
    ];
    configOverrides.misc.vrr = 3;
    extraStartupCommands = ["openrgb --startminimized"];
    workspaceRules = [
      {
        workspace = "1";
        monitor = primary;
      }
      {
        workspace = "2";
        monitor = primary;
      }
      {
        workspace = "3";
        monitor = primary;
      }
      {
        workspace = "4";
        monitor = primary;
      }
      {
        workspace = "5";
        monitor = primary;
      }
      {
        workspace = "6";
        monitor = secondary;
      }
      {
        workspace = "7";
        monitor = secondary;
      }
      {
        workspace = "8";
        monitor = secondary;
      }
      {
        workspace = "9";
        monitor = secondary;
      }
      {
        workspace = "10";
        monitor = secondary;
      }
    ];
  };
}
