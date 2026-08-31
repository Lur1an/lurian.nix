{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lurian.terminal.fonts.enable {
    home.packages = [(pkgs.callPackage ./package.nix {})];
  };
}
