{
  config,
  pkgs,
  ...
}: 
let 
  languageServers = with pkgs; [
      lua-language-server
      helm-ls
      yaml-language-server
      tailwindcss-language-server
      yamlfix
      pyright
      basedpyright
      docker-compose-language-service
      dockerfile-language-server-nodejs
      nodePackages.typescript-language-server
      stylua
      nodePackages.svelte-language-server
      black
      pyright
      marksman
      nodePackages.graphql-language-service-cli
  ];
in
{
  home.packages = (with pkgs; [
    gnumake
    gcc
    fd
    nodejs
    tree-sitter
  ]);
  programs.neovim = {
    enable = true;
    extraPackages = (with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          vadimcn.vscode-lldb
          ms-python.vscode-pylance
        ];
      })
    ]) ++ languageServers;
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
