{
  config,
  pkgs,
  ...
}: {
  home.file.".config/alacritty".source = ../dotfiles/alacritty;
  home.file.".zshrc".source = ../dotfiles/zsh/.zshrc;
  home.file.".xresources".source = ../dotfiles/zsh/.xresources;
  home.file.".tmux.conf".source = ../dotfiles/tmux/.tmux.conf;
}

