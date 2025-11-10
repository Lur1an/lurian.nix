{
  inputs,
  outputs,
  lib,
  config,
  machineConfig,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hyprland.nix
    ./polkit.nix
  ];
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      glib
      glibc
      zlib
      libz
      fuse3
      clang
      libclang
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
  };
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

  networking = {
    firewall.enable = false;
    enableIPv6 = false;
    networkmanager.enable = true;
  };
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
      trusted-users = ["lurian" "root"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  home-manager = {
    backupFileExtension = "hm-bak";
    useUserPackages = true;
    verbose = true;
    useGlobalPkgs = false;
    extraSpecialArgs = {inherit inputs outputs machineConfig;};
    users = {
      lurian = import ../home-manager/profiles/linux.nix;
    };
  };

  users.users = {
    lurian = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "Lurian";
      extraGroups = ["wheel" "networkmanager" "docker" "audio" "storage" "dialout"];
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

  services.xserver = {
    enable = true;
    xkb.options = "caps:escape";
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [pkgs.mesa];
  };

  # bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

  # sound
  services.pulseaudio.enable = false;
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

  services.resolved.enable = true;
  services.udev.packages = [pkgs.bazecor];
  environment.systemPackages = with pkgs; [
    killall
    curl
    hwinfo
    matugen
    ntfs3g
    bazecor
    sysstat
    git
    portaudio
    pciutils
    usbutils
    udev
    mpv
    libglvnd
    gh
  ];
}
