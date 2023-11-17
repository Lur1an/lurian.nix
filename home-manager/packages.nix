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
    slack
    telegram-desktop
    htop
    easyeffects
    neofetch
    networkmanagerapplet
    slurp
    grim
    pavucontrol
    playerctl
  ];
}
