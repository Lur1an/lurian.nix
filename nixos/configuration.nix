# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  nix-colors,
  machineConfig,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hyprland.nix
    ./i18n.nix
    ./gnome.nix
    ./audio.nix
    ./polkit.nix
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    glib
    glibc
    zlib
    fuse3
    icu
    zlib
    nss
    openssl
    udev
    curl
    expat
    nspr
    xorg.libxcb
  ];
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "nix-2.16.2"
      ];
    };
  };

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      warn-dirty = false;
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 13;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    extraSpecialArgs = {inherit inputs outputs nix-colors machineConfig;};
    users = {
      lurian = import ../home-manager/home.nix;
    };
  };

  users.users = {
    lurian = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "Lurian";
      extraGroups = ["wheel" "networkmanager" "docker" "audio" "storage" "video" "input" "uinput" "libvirtd"];
    };
  };

  # Printing stuff
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Flatpak
  xdg.portal.enable = true;

  services.dbus.enable = true;
  services.flatpak.enable = true;

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  services.xserver = {
    enable = true;
    xkb.options = "caps:escape";
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = false;

  # Nvidia drivers
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    nvidia = {
      open = false;
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [pkgs.mesa.drivers];
    };
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.udev.packages = [pkgs.bazecor];
  environment.systemPackages = with pkgs; [
    nixd
    vim
    wget
    killall
    curl
    hyprlock
    bazecor
    sops
    sysstat
    git
    gh
    pciutils
    usbutils
    udev
    gtk3
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    libglvnd
  ];
  system.stateVersion = "23.11";
}
