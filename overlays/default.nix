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
    
    opencode = prev.opencode.overrideAttrs (oldAttrs: rec {
      version = "0.10.3";
      src = oldAttrs.src.override {
        tag = "v${version}";
        hash = "sha256-NE24parzEawK66AFhqQbKCM3Y4uSxAjHIOpnnAcL6ec=";
      };
      tui = oldAttrs.tui.overrideAttrs (old: {
        vendorHash = "sha256-H+TybeyyHTbhvTye0PCDcsWkcN8M34EJ2ddxyXEJkZI=";
      });
      node_modules = oldAttrs.node_modules.overrideAttrs (old: {
        buildPhase = ''
          runHook preBuild
          export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
          bun install \
            --filter=opencode \
            --force \
            --ignore-scripts \
            --no-progress
          runHook postBuild
        '';
        outputHash = "sha256-fGf2VldMlxbr9pb3B6zVL+fW1S8bRjefJW+jliTO73A=";
      });
    });
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
