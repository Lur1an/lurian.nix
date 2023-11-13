{ ... }: {
  config = {
    services.picom = {
      enable = true;
    };
    services.xserver = {
      autorun = true;
      windowManager.i3 = {
        enable = true;
      };
      displayManager = {
        gdm.enable = true;
        defaultSession = "none+i3";
      };
      videoDrivers = [ "nvidia" ];
    };
  };
}
