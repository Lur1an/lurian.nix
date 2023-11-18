{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # RUST TOOLING
    rustup
    openssl
    poetry
    pkg-config
  ];
}
