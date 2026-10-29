{
  description = "Lurian's Nix Config";

  inputs = {
    # Include vendored Git submodules in the flake source.
    self.submodules = true;

    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    terminal = {
      url = "path:./flakes/terminal";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    claude-api = {
      url = "path:./flakes/anthroxy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wayland/Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    xdg-portal-hyprland.inputs.nixpkgs.follows = "nixpkgs";

    qmd = {
      # Adds an overridable acceleration argument and the corresponding CUDA
      # runtime libraries for node-llama-cpp's prebuilt backend.
      url = "github:Lur1an/qmd/fix/nix-gpu-acceleration";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
      ];

      perSystem = {pkgs, ...}: let
        localPackages = import ./pkgs {
          inherit pkgs inputs;
        };
      in {
        packages =
          localPackages
          // inputs.terminal.packages.${pkgs.stdenv.hostPlatform.system};

        formatter = pkgs.alejandra;

        checks.qmllint = pkgs.runCommand "quickshell-qmllint" {env.LC_ALL = "C.UTF-8";} ''
          cd ${./home-manager/quickshell/qml}
          find . -name '*.qml' -print0 | xargs -0 ${pkgs.qt6.qtdeclarative}/bin/qmllint \
            --max-warnings 0 \
            -I ${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix} \
            -I ${pkgs.qt6.qtmultimedia}/${pkgs.qt6.qtbase.qtQmlPrefix} \
            -I ${pkgs.quickshell}/${pkgs.qt6.qtbase.qtQmlPrefix}
          touch "$out"
        '';
      };

      flake = {
        overlays = import ./overlays {
          inherit inputs;
          outputs = inputs.self;
        };

        nixosConfigurations = {
          desktop = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              outputs = inputs.self;
            };
            modules = [
              ./systems/desktop/configuration.nix
            ];
          };
          zephyrus = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              outputs = inputs.self;
            };
            modules = [
              ./systems/zephyrus/configuration.nix
            ];
          };
        };
      };
    };
}
