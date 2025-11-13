{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.rust;
in {
  options.rust = {
    debugger.enable = lib.mkEnableOption "Rust debugger (vscode-lldb)";
    slim = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Only install rustup, exclude additional cargo tools";
    };
  };

  config = {
    home.packages =
      (with pkgs;
        [rustup]
        ++ lib.optionals (!cfg.slim) [
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
        ])
      ++ lib.optionals cfg.debugger.enable [
        (pkgs.vscode-with-extensions.override {
          vscodeExtensions = with pkgs.vscode-extensions; [
            vadimcn.vscode-lldb
          ];
        })
      ];

    home.file.".vscode-lldb" = lib.mkIf cfg.debugger.enable {
      source = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";
    };
  };
}
