{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    barrier
    discord
    slack
    rustup
    telegram-desktop
    python311Full
  ];
}
