{ pkgs, ... }: {
  config = {
    services.picom = {
      enable = true;
    };
    services.xserver = {
      desktopManager.session = [
        {
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];
      # displayManager = {
      #   lightdm = {
      #     enable = true;
      #     greeters.gtk = {
      #       enable = true;
      #     };
      #   };
      #   defaultSession = "none+i3";
      # };
      # windowManager.i3 = {
      #   enable = true;
      #   extraPackages = with pkgs; [ i3status i3lock i3blocks ];
      # };
    };
  };
}
