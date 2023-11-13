{ ... }: {
  config = {
    services.picom = {
      enable = true;
    };
    services.xserver = {
      autorun = false;
      windowManager.i3 = {
        enable = true;
      };
      displayManager.sddm.enable = true;
      desktopManager = {
        default = "none";
        xterm.enable = false;
      }
        # defaultSession = "none+i3";
      };
    };
  };
}
