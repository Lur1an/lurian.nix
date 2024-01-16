{
  config,
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gnumake
    gcc
    fd
    nodejs
    tree-sitter
  ];
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      lua-language-server
      nil
      rust-analyzer
    ];
  };
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/nvim";
  home.file.".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/intellij/.ideavimrc";
  # home.file.".config/nvim".source = ../dotfiles/nvim;
}
