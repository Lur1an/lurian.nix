{
  pkgs,
  config,
  ...
}: let
  colors = config.colorscheme.palette;
in {
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
      set -s escape-time 0
      set -g default-terminal "screen-256color"
      set-window-option -g window-status-current-style fg="#${colors.base06}"
      set-environment -g COLORTERM "truecolor"
      set -ga terminal-overrides ',*256col*:Tc'
      set -g @catppuccin-flavour 'mocha'
    '';
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.catppuccin
    ];
  };
}
