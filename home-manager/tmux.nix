{ pkgs, config, ... }:
let
  colors = config.colorscheme.colors;
in
{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -s escape-time 0
      set -g status-bg "#${colors.base01}"
      set -g status-fg "#${colors.base00}"
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ',*256col*:Tc'
    '';
  };
}
