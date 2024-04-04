{pkgs, ...}: {
  home.packages = with pkgs; [
    android-tools
    jdk21
    # RUST TOOLING
    protobuf
    kubernetes-helm
    grpcui
    rustup
    openssl.dev
    poetry
    pkg-config
    lldb
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        vadimcn.vscode-lldb
        ms-python.vscode-pylance
      ];
    })
    flatbuffers
    # NODEJS
    bun
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
    # Networking
    wireshark-cli
    termshark
    # Go
    go
    cmake
    rover
  ];

  home.file.".vscode-lldb".source = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";

  home.sessionVariables = {
    PYLANCE_PATH = "${pkgs.vscode-extensions.ms-python.vscode-pylance}";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    JAVA_21_HOME = "${pkgs.jdk21}";
  };
}
