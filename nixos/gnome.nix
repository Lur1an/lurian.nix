{ pkgs, ... }: {
  config = {
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;    
    };

    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-contacts
      gnome-initial-setup
    ]);
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      xdg-desktop-portal-gtk 
    ];
  };
}
