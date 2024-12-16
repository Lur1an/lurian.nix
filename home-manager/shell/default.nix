{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./aider.nix
    ./foot.nix
    ./tmux
  ];
  home.packages = with pkgs; [
    direnv
    warp-terminal
    nushell
    neofetch
  ];
}
