{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    sea-orm-cli
    sqlx-cli
    clang
    pkg-config
    cmake
    cargo-make
    cargo-hack
    cargo-flamegraph
    cargo-nextest
    cargo-udeps
    cargo-watch
  ];
}
