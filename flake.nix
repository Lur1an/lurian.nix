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

    # Neovim
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    omp = {
      url = "github:can1357/oh-my-pi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wayland/Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprwinwrap = {
      url = "github:gen3vra/hyprwinwrap/0f23c7a1a8ef82d65ba5981cd5f4ab251da73f44";
      flake = false;
    };
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    xdg-portal-hyprland.inputs.nixpkgs.follows = "nixpkgs";

    qmd = {
      # Fork adds an overridable `acceleration` arg + fixes node-llama-cpp
      # prebuilt loading (libstdc++ / CUDA runtime libs on LD_LIBRARY_PATH).
      url = "github:Lur1an/qmd/fix/nix-gpu-acceleration";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treehouse = {
      url = "github:kunchenguid/treehouse";
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
        nixvimFlakePackages =
          builtins.removeAttrs localPackages.nixvimPackages
          ["recurseForDerivations" "supermaven-agent"];
      in {
        packages = builtins.removeAttrs localPackages ["nixvimPackages"] // nixvimFlakePackages;

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
      };
    };
}
