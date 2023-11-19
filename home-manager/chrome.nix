{
  config,
  pkgs,
  ...
}: let
  wrapper-manager =
    import (builtins.fetchTarball {
      url = "https://github.com/viperML/wrapper-manager/archive/c9debabc8225d96c87e7ff5e86ddc39af694fada.tar.gz";
      sha256 = "0lfq5dgqbfpj3jgiml91fcsa509a0xz7iqavkdss7d9r3b0gi5dc";
    }) {
      inherit (pkgs) lib;
    };
in {
  home.packages = [
    (wrapper-manager.lib.build {
      inherit pkgs;
      modules = [
        {
          wrappers.chrome = {
            basePackage = pkgs.google-chrome;
            renames."google-chrome-stable" = "google-chrome";
          };
        }
      ];
    })
  ];
}
