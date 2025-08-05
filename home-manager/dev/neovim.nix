{
  config,
  pkgs,
  ...
}: let
  languageServers = with pkgs; [
    lua-language-server
    terraform-ls
    helm-ls
    yamlfix
    ansible-language-server
    yaml-language-server
    tailwindcss-language-server
    # yamlfix
    pyright
    basedpyright
    docker-compose-language-service
    dockerfile-language-server-nodejs
    sqruff
    isort
    ruff
    mypy
    stylua
    black
    marksman
    nodePackages_latest.typescript-language-server
    nodePackages_latest.svelte-language-server
  ];
in {
  home.packages = with pkgs;
    [
      gnumake
      fd
      isort
      ruff
      tree-sitter
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          vadimcn.vscode-lldb
          ms-python.vscode-pylance
        ];
      })
    ]
    ++ languageServers;
  programs.neovim = {
    enable = true;
  };
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/nvim";
  home.file.".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/.ideavimrc";

  home.file.".vscode-lldb".source = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";

  home.sessionVariables = {
    PYLANCE_PATH = "${pkgs.vscode-extensions.ms-python.vscode-pylance}";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    JAVA_21_HOME = "${pkgs.jdk21}";
  };
}
