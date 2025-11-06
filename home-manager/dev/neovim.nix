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
    dockerfile-language-server
    sqruff
    isort
    just-lsp
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
      ruff
      tree-sitter
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          vadimcn.vscode-lldb
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
}
