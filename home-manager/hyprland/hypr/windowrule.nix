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
  "opacity 0.9,^(discord)"
  "opacity 0.9,telegram*"
  "workspace 3 silent, ^(discord)"
  "workspace 3 silent, telegram*"
  "workspace 5 silent, ^(firefox)"
  "workspace 7 silent, ^(chromium)"
  "workspace 7 silent, ^(google-chrome)"
]
