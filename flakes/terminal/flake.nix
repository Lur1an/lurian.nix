{
  description = "Reusable terminal and Neovim Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    omp = {
      url = "github:can1357/oh-my-pi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treehouse = {
      url = "github:kunchenguid/treehouse";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    forAllSystems = inputs.nixpkgs.lib.genAttrs systems;
    module = import ./modules {inherit inputs;};
    pkgsFor = system: import inputs.nixpkgs {inherit system;};
  in {
    homeModules.default = module;

    packages = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      tree-sitter-verus = pkgs.callPackage ./modules/neovim/tree-sitter-verus.pkg.nix {};
      tree-sitter-surrealql = pkgs.callPackage ./modules/neovim/tree-sitter-surrealql.pkg.nix {};
      omp-undo-redo = pkgs.callPackage ./modules/omp/undo-redo.pkg.nix {};
      lurianFonts = pkgs.callPackage ./modules/fonts/package.nix {};
    });

    formatter = forAllSystems (system: (pkgsFor system).alejandra);

    checks = forAllSystems (system:
      import ./checks.nix {
        inherit inputs module system;
        pkgs = pkgsFor system;
      });
  };
}
