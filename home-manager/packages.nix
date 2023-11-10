{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    firefox
    discord
    slack
    neovim
    tmux
    rustup
    telegram-desktop
    python311Full
  ];
}
