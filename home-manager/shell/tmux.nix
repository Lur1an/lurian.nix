{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
      set -s escape-time 0
      set -g default-terminal "screen-256color"
      set-environment -g COLORTERM "truecolor"
      set -ga terminal-overrides ',*256col*:Tc'
    '';
    plugins = with pkgs; [
      tmuxPlugins.weather
    ];
  };
}
