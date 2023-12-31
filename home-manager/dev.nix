{pkgs, ...}: {
  home.packages = with pkgs; [
    # RUST TOOLING
    protobuf
    grpcui
    rustup
    openssl.dev
    poetry
    pkg-config
    lldb
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        vadimcn.vscode-lldb
      ];
    })
    # NODEJS
    nodejs
    tailwindcss
    typescript
    nodePackages.npm # Package manager
    nodePackages.pnpm # Package manager
    nodePackages.node2nix
    nodePackages.live-server # Live server
    nodePackages.typescript-language-server # Typescript
    nodePackages_latest.eslint_d # JS linter
    nodePackages_latest.prettier # Formatter
  ];

  home.file.".vscode-lldb".source = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
