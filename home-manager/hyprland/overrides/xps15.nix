{...}: {
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        ",preferred,auto, 1.50"
      ];
      bind =
        import ../binds.nix
        ++ [
          # XPS15 specific binds can be added here
          ",XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ",XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ];
      windowrule =
        import ../windowrule.nix
        ++ [
          # XPS15 specific window rules can be added here
        ];
    };
  };
}
