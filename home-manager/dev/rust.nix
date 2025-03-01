{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    cargo-make
    cargo-flamegraph
    cargo-nextest
    cargo-udeps
    cargo-watch
    sea-orm-cli
    sqlx-cli
    clang
    pkg-config
    cmake
  ];
}
