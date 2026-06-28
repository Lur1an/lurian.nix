{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    ruff
    ripgrep
    # tree-sitter-manager.nvim compiles parsers at runtime. It also needs a C
    # compiler (clang, from modules/lurian.nix), git and node (home-manager/node.nix).
    tree-sitter
  ];
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/nvim";
}
