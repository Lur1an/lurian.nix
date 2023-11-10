{
  config,
  pkgs,
  ...
}: {
  home.file.".config/nvim".source = ../dotfiles/nvim;
  home.file.".fonts".source = ../dotfiles/fonts;
  home.file.".config/alacritty".source = ../dotfiles/alacritty;
  home.file.".zshrc".source = ../dotfiles/zshrc;
  home.file.".tmux.conf".source = ../dotfiles/tmux/.tmux.conf;
}

