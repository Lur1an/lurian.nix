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
      version = "0.3.112"; # Update this to the latest version
      src = prev.fetchFromGitHub {
        owner = "sst";
        repo = "opencode";
        tag = "v${version}";
        sha256 = "BeUgZUzuphQ1gqPnDnKP2HMy5nyoD5au4AekGT2deIc=";
      };
    });
    
    # basedpyright = prev.basedpyright.overrideAttrs (oldAttrs: {
    #   version = "1.24.0";
    #   src = prev.fetchFromGitHub {
    #     owner = "detachhead";
    #     repo = "basedpyright";
    #     tag = "v1.24.0";
    #     hash = "sha256-46Icd8zrblD3fSeY1izEOMrYwTv+a4YE1cmMYUJtewk=";
    #   };
    #   npmDepsHash = "";
    # });
    # jetbrains =
    #   prev.jetbrains
    #   // {
    #     rust-rover = prev.jetbrains.rust-rover.overrideAttrs (oldAttrs: {
    #       version = "2024.1.3";
    #       src = prev.fetchurl {
    #         url = "https://download-cdn.jetbrains.com/rustrover/RustRover-2024.2.tar.gz";
    #         sha256 = "U8B2gV4lfpF6Wj26U6WZDgeag7aRldV6LAxy+2Gudug=";
    #       };
    #     });
    #   };
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
