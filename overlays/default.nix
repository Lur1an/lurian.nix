# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev:
    import ../pkgs {
      pkgs = final;
      inputs = inputs;
    };
  # This one contains whatever you want to overlay
  modifications = final: prev: {
    ollama = prev.ollama.override {acceleration = "cuda";};
    # Pin Neovim to 0.11.6 (0.12 breaks nvim-treesitter query_predicates)
    # https://github.com/nvim-treesitter/nvim-treesitter/issues/8636
    neovim-unwrapped = inputs.neovim-pin.legacyPackages.${prev.system}.neovim-unwrapped;
  };
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
