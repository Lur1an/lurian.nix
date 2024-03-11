{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "pop-shell@system76.com"
        ];
      };
      "org/gnome/shell/extensions/pop-shell" = {
        gap-outer = "uint 16";
        show-title = false;
        tile-by-default = true;
      };
    };
}
