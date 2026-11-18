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
    minikube = prev.minikube.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          rm $out/bin/kubectl
        '';
    });

    bazecor = final.symlinkJoin {
      name = "bazecor";
      paths = [prev.bazecor];
      nativeBuildInputs = [final.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/bazecor --add-flags "--ozone-platform=wayland"
      '';
      inherit (prev.bazecor) meta;
    };

    qmd = inputs.qmd.packages.${final.stdenv.hostPlatform.system}.default.override {
      acceleration = "cuda";
    };
  };
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
