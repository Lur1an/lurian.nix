{ ... }: {
  config = {
    services.xserver = {
      autorun = false;
      windowManager.i3 = {
        enable = true;
      };
      displayManager = {
        lightdm = {
          enable = true;
          greeters.gtk = {
            enable = true;
          };
        };
      desktopManager = {
        default = "none";
        xterm.enable = false;
      }
        # defaultSession = "none+i3";
      };
    };
  };
}
