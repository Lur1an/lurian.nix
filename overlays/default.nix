# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev:
    import ../pkgs {
      pkgs = final;
    };
  # This one contains whatever you want to overlay
  modifications = final: prev: {
    ollama = prev.ollama.override {acceleration = "cuda";};
    jetbrains =
      prev.jetbrains
      // {
        rust-rover = prev.jetbrains.rust-rover.overrideAttrs (oldAttrs: {
          version = "2024.1.3";
          src = prev.fetchurl {
            url = "https://download-cdn.jetbrains.com/rustrover/RustRover-2024.1.3.tar.gz";
            sha256 = "0hfhxrlprzhlgw7xhrfkl31janz85avfbn1ilbcwbpsvldpvpad3";
          };
        });
      };
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
