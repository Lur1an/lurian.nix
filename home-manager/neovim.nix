{ config, inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    gcc
    fd
    nodejs
    tree-sitter
  ];
  programs.neovim.enable = true;
  home.file.".config/nvim".source = ../dotfiles/nvim;
}
