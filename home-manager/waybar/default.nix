{
  config,
  pkgs,
  lib,
  ...
}: {
  # Media control for the waybar cava module (play-pause / next / previous)
  services.playerctld.enable = true;
  home.packages = [pkgs.playerctl];

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

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "cava"
        ];

        modules-right = [
          "tray"
          "wireplumber"
          "network"
          "cpu"
          "memory"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          persistent-workspaces = {
            "*" = 5;
          };
        };

        cava = {
          method = "pipewire";
          source = "auto";
          framerate = 30;
          bars = 14;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          autosens = 1;
          noise_reduction = 0.77;
          input_delay = 2;
          sleep_timer = 5;
          hide_on_silence = false;
          format_silent = "󰝛";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          bar_delimiter = 0;
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
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

      #cava {
        padding: 0 12px;
        color: @primary;
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
