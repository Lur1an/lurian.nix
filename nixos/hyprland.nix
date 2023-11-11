{ pkgs, inputs, hyprland, ... }: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  hardware = {
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    videoDrivers = [ "nvidia" ];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };

  environment.systemPackages = with pkgs; [
    swaybg
    mako
    libnotify
    swaylock
    wl-clipboard
    wl-clip-persist
    # Pulseaudio to expose pactl
    pulseaudio
    wireplumber
    xwaylandvideobridge
    gnome.seahorse
  ];
}
