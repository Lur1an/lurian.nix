{
  pkgs,
  config,
  ...
}: let
  colors = config.colorscheme.colors;
in {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -s escape-time 0
      set -g status-bg "#${colors.base01}"
      set -g status-fg "#${colors.base05}"
      set -g default-terminal "screen-256color"
      set-window-option -g window-status-current-style fg="#${colors.base06}"
      set -ga terminal-overrides ',*256col*:Tc'
    '';
  };
}
