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
    inputs.nix-ld.nixosModules.nix-ld
    ./hyprland.nix
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
    # You can add overlays here
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
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
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
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
      extraGroups = ["wheel" "networkmanager" "docker" "audio"];
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
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
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = [pkgs.mesa.drivers];
    };
  };

  # sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.udev.packages = [pkgs.bazecor];
  environment.systemPackages = with pkgs; [
    nixd
    vim
    wget
    inputs.self.packages.${system}.lurian-etcher
    killall
    curl
    bazecor
    git
    sops
    sysstat
    git
    gh
    mpv
    pciutils
    udev
    telepresence2
    gtk3
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    libglvnd
  ];
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
