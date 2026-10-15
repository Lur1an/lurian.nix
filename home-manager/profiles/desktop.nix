{
  config,
  lib,
  pkgs,
  ...
}: let
  primary = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009629";
  secondary = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009657";
  primaryWaybar = "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009629";
  opencodeWeb = pkgs.writeShellScript "opencode-web" ''
    export PATH=${lib.makeBinPath ([config.programs.opencode.package] ++ config.programs.opencode.extraPackages)}
    # Register this server for automatic discovery by terminal clients.
    exec opencode serve --service --port 4098 --hostname 127.0.0.1
  '';
in {
  imports = [
    ./linux.nix
  ];


  programs.waybar.settings.mainBar.output = ["${primaryWaybar}"];

  lurian.quickshell.wallpaperPicker.directories = ["/mnt/Shared/Videos/Vpapers"];

  # Big local model also available in aichat (`aichat -m ollama:qwen3.6:27b`)
  lurian.terminal = {
    zshAi.extraModels = ["qwen3.8:27b"];
    tmux.projectDirs = [
      "~/Projects"
      "/mnt/Data"
      "~/lurian.nix"
    ];
    treehouse = {
      enable = true;
      root = "/mnt/Data";
    };
  };

  programs.zsh.shellAliases.tailscale-opencode = ''${pkgs.tailscale}/bin/tailscale --socket="$XDG_RUNTIME_DIR/opencode-tailscale/tailscaled.sock"'';

  systemd.user.services = lib.mkIf config.lurian.terminal.opencode.enable {
    opencode-web = {
      Unit = {
        Description = "OpenCode API Service";
        StartLimitIntervalSec = 0;
      };

      Service = {
        ExecStart = opencodeWeb;
        WorkingDirectory = config.home.homeDirectory;
        Restart = "always";
        RestartSec = 5;
      };

      Install.WantedBy = ["default.target"];
    };

    # Sign in once through this daemon's private socket; its identity is persisted.
    opencode-tailscale = {
      Unit = {
        Description = "OpenCode userspace Tailscale service";
        StartLimitIntervalSec = 0;
      };

      Service = {
        ExecStart = "${pkgs.tailscale}/bin/tailscaled --tun=userspace-networking --port=0 --statedir=%S/opencode-tailscale --socket=%t/opencode-tailscale/tailscaled.sock";
        StateDirectory = "opencode-tailscale";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "opencode-tailscale";
        RuntimeDirectoryMode = "0700";
        UMask = "0077";
        Restart = "always";
        RestartSec = 10;
      };

      Install.WantedBy = ["default.target"];
    };

    opencode-tailscale-serve = {
      Unit = {
        Description = "Expose OpenCode within the userspace tailnet";
        Wants = ["opencode-tailscale.service" "opencode-web.service"];
        After = ["opencode-tailscale.service" "opencode-web.service"];
        PartOf = ["opencode-tailscale.service"];
        StartLimitIntervalSec = 0;
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.tailscale}/bin/tailscale --socket=%t/opencode-tailscale/tailscaled.sock serve --bg --yes --tcp=4098 tcp://127.0.0.1:4098";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = 10;
        TimeoutStartSec = 60;
      };

      Install.WantedBy = ["default.target"];
    };
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
