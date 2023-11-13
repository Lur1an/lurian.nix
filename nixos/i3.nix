{ ... }: {
  config = {
    services.xserver = {
      windowManager.i3 = {
        enable = true;
      };
      displayManager = {
        lightdm = {
          enable = true;
          greeter.enable = true;
          greeters.gtk = {
            enable = true;
          };
        };
        gdm = {
          enable = true;
        };
        defaultSession = "none+i3";
      };
      desktopManager.session = [
        {
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];
    };
  };
}
