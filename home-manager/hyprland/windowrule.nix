let
  f = regex: "float, ^(${regex})$";
in [
  (f "org.gnome.Calculator")
  (f "org.gnome.Nautilus")
  (f "pavucontrol")
  (f "nm-connection-editor")
  (f "blueberry.py")
  (f "org.gnome.Settings")
  (f "org.gnome.design.Palette")
  (f "Color Picker")
  (f "xdg-desktop-portal")
  (f "xdg-desktop-portal-gnome")
  (f "de.haeckerfelix.Fragments")
  (f "com.github.Aylur.ags")
  (f "pavucontrol")
  "opacity 0.9,^(vesktop)"
  "opacity 0.9, ^(org.telegram.desktop)"
  "opacity 0.9,^(Slack)"
  "workspace 7 silent, ^(vesktop)"
  "workspace 7 silent, ^(Slack)"
  "workspace 7 silent, ^(org.telegram.desktop)"
  "workspace 6 silent, ^(firefox)"
  "workspace 8 silent, camoufox-default"
  "workspace 8 silent, ^(chromium)"
  "workspace 8 silent, ^(google-chrome)"
]
