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
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        vadimcn.vscode-lldb
      ];
    })
    cargo-watch
  ];
  home.file.".vscode-lldb".source = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";
}
