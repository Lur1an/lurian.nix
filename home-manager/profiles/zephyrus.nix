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
    {
      keys = "XF86MonBrightnessUp";
      command = "brightnessctl -d intel_backlight set 10%+";
    }
    {
      keys = "XF86MonBrightnessDown";
      command = "brightnessctl -d intel_backlight set 10%-";
    }
  ];
  hyprdesktop.customWindowRules = [
    {
      class = "^(discord)$";
      workspace = "3";
    }
    {
      class = "^(vesktop)$";
      workspace = "3";
    }
    {
      class = "^(Slack)$";
      workspace = "3";
    }
    {
      class = "^(org.telegram.desktop)$";
      workspace = "3";
    }
    {
      class = "^(firefox)$";
      workspace = "2";
    }
    {
      class = "^camoufox-default$";
      workspace = "8";
    }
    {
      class = "^(chromium-browser)$";
      workspace = "8";
    }
    {
      class = "^(google-chrome)$";
      workspace = "8";
    }
  ];
}
