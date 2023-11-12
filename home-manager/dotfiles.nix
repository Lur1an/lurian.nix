{
  config,
  pkgs,
  ...
}: {
  home.file.".zshrc".source = ../dotfiles/zsh/.zshrc;
  home.file.".xresources".source = ../dotfiles/zsh/.xresources;
}

