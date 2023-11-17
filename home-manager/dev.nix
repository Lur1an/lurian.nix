{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # RUST TOOLING
    rustup
    openssl
    pkg-config
  ];
}
