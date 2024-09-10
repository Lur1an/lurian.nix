{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    cargo-make
    cargo-flamegraph
    cargo-nextest
    cargo-udeps
    cargo-watch
    cargo-llvm-cov
    sea-orm-cli
  ];
}
