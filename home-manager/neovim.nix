{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    ruff
    ripgrep
    tree-sitter
  ];
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/nvim";
}
