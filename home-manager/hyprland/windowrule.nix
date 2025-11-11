let
  floatingWindow = regex: "float, class:^(${regex})$";
in
  map floatingWindow [
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
    "de.haeckerfelix.Fragments"
  ]
