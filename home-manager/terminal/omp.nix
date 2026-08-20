{
  inputs,
  pkgs,
  ...
}: let
  package = inputs.omp.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  imports = [inputs.omp.homeManagerModules.default];

  programs.omp = {
    enable = true;
    inherit package;
    settings = {
      startup.quiet = true;
    };
  };
}
