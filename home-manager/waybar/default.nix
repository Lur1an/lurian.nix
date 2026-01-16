{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        spacing = 4;
        margin-top = 4;
        margin-left = 8;
        margin-right = 8;
        reload_style_on_change = true;
        output = ["DP-4"];

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "tray"
          "wireplumber"
          "network"
          "cpu"
          "memory"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          persistent-workspaces = {
            "*" = 5;
          };
        };

        clock = {
          format = "󰥔 {:%H:%M}";
          format-alt = "󰃭 {:%a %d %b}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        tray = {
          icon-size = 14;
          spacing = 8;
        };

        wireplumber = {
          format = "󰕾 {volume}%";
          format-muted = "󰝟 muted";
          on-click = "pavucontrol";
          tooltip-format = "{node_name}";
        };

        network = {
          format-wifi = "󰤨 {signalStrength}%";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
          tooltip-format-wifi = "{essid}\n{ipaddr}";
          tooltip-format-ethernet = "{ifname}\n{ipaddr}";
          on-click = "nm-connection-editor";
        };

        cpu = {
          format = "󰻠 {usage}%";
          interval = 2;
          on-click = "ghostty -e htop";
        };

        memory = {
          format = "󰍛 {percentage}%";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
          interval = 2;
          on-click = "ghostty -e htop";
        };
      };
    };

    style = ''
      @import "${config.home.homeDirectory}/.cache/matugen/waybar-colors.css";

      * {
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", monospace;
        font-size: 12px;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background: transparent;
      }

      window#waybar > box {
        background: alpha(@surface, 0.9);
        border: 1px solid alpha(@outline-variant, 0.5);
        border-radius: 10px;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding: 2px 8px;
        color: @on-surface-variant;
        background: transparent;
        border-radius: 6px;
      }

      #workspaces button:hover {
        background: alpha(@primary, 0.15);
        color: @primary;
      }

      #workspaces button.active {
        color: @primary;
        font-weight: bold;
      }

      #workspaces button.urgent {
        color: @error;
      }

      #clock {
        padding: 0 12px;
        color: @on-surface;
        font-weight: bold;
      }

      #tray {
        padding: 0 8px;
      }

      #wireplumber,
      #network,
      #cpu,
      #memory {
        padding: 0 10px;
        color: @on-surface;
      }

      #wireplumber.muted {
        color: @on-surface-variant;
      }

      #network.disconnected {
        color: @on-surface-variant;
      }

      tooltip {
        background: @surface;
        border: 1px solid @outline-variant;
        border-radius: 8px;
      }

      tooltip label {
        color: @on-surface;
        padding: 4px 8px;
      }
    '';
  };
}
