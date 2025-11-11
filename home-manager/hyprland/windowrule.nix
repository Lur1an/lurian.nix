{config, ...}: let
  floatingWindow = regex: "float, class:^(${regex})$";
  cfg = config.hyprdesktop;
in {
  wayland.windowManager.hyprland.settings.windowrulev2 =
    (map floatingWindow ([
        "org.gnome.Calculator"
        "org.gnome.Nautilus"
        "pavucontrol"
        "nm-connection-editor"
        "blueberry.py"
        "org.gnome.Settings"
        "org.gnome.design.Palette"
        "Color Picker"
        "xdg-desktop-portal"
        "xdg-desktop-portal-gnome"
      ]
      ++ cfg.floatingWindows))
    ++ cfg.windowRules;
}
