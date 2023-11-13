{ pkgs, ... }: {
  config = {
    services.picom = {
      enable = true;
    };
    services.xserver = {
      autorun = true;
      desktopManager = {
        xterm.enable = false;
        # xfce = {
        #   enable = true;
        #   noDesktop = true;
        #   enableXfwm = false;
        # };
      };
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
        extraPackages = with pkgs; [ i3status i3lock i3blocks ];
      };
    };
  };
}
