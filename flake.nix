{
  description = "Lurian's Nix Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Wayland/Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem = {pkgs, ...}: {
        packages = import ./pkgs {
          pkgs = pkgs;
          inputs = inputs;
        };

        formatter = pkgs.alejandra;
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

        darwinConfigurations = {};
      };
    };
}
