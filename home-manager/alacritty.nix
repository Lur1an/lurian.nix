{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
  };
  home.file.".config/alacritty".source = ../dotfiles/alacritty;
}
