{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ruff
    ripgrep
    tree-sitter
  ];
  programs.neovim = {
    enable = true;
  };
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/nvim";
}
