{...}: {
  programs.waybar = {
    settings.mainBar = {
      output = ["eDP-1"];

      modules-right = [
        "battery"
      ];

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󰚥 {capacity}%";
        format-full = "󰁹 Full";
        format-icons = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        tooltip-format = "{timeTo}\n{power:.1f}W\n{health}%";
      };
    };

    style = ''
      #battery {
        padding: 0 10px;
        color: @on-surface;
      }

      #battery.warning {
        color: @error;
      }

      #battery.critical {
        color: @error;
        animation: blink 1s infinite;
      }

      @keyframes blink {
        to {
          color: @on-surface;
        }
      }
    '';
  };

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
