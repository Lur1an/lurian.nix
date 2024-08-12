{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    cargo-make
    cargo-flamegraph
    cargo-nextest
    cargo-watch
    cargo-llvm-cov
    sea-orm-cli
  ];
}
