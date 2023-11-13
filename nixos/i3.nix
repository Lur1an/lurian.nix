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
      displayManager.sddm.enable = true;
      displayManager.sddm.settings.General.DisplayServer = "x11-user";
      defaultSession = "none+i3";
    };
  };
}
