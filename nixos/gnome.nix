{ pkgs, ... }: {
  config = {
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;    
    };

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-contacts
      gnome-initial-setup
    ]);
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
    ];
  };
}
