{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    cargo-make
    cargo-flamegraph
    cargo-watch
    cargo-llvm-cov
    sea-orm-cli
  ];
}
