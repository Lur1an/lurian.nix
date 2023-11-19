{pkgs, ...}: {
  config = {
    services.picom = {
      enable = true;
    };
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    services.xserver = {
      displayManager = {
        lightdm = {
          enable = true;
          greeters.gtk = {
            enable = true;
          };
        };
        defaultSession = "none+i3";
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [i3status i3lock i3blocks];
      };
    };

    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
