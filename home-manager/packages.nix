{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    exa # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    barrier
    discord
    slack
    neovim
    tmux
    rustup
    telegram-desktop
    python311Full
    alacritty
  ];
}
