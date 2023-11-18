{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # RUST TOOLING
    rustup
    openssl.dev
    poetry
    pkg-config
  ];
  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
