{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./aider.nix
    ./foot.nix
    ./tmux
    ./ghostty.nix
    ./opencode.nix
  ];
  home.packages = with pkgs; [
    direnv
    warp-terminal
    nushell
    neofetch
  ];
}
