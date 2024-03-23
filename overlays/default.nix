# This file defines overlays
{
  inputs,
  nixpkgs,
  ...
}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = nixpkgs;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    pythonPackagesExtensions =
      prev.pythonPackagesExtensions
      ++ [
        (
          python-final: python-prev: {
            catppuccin = python-prev.catppuccin.overridePythonAttrs (oldAttrs: rec {
              version = "1.3.2";
              src = prev.fetchFromGitHub {
                owner = "catppuccin";
                repo = "python";
                rev = "refs/tags/v${version}";
                hash = "sha256-spPZdQ+x3isyeBXZ/J2QE6zNhyHRfyRQGiHreuXzzik=";
              };

              # can be removed next version
              disabledTestPaths = [
                "tests/test_flavour.py" # would download a json to check correctness of flavours
              ];
            });
          }
        )
      ];
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
