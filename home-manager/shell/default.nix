{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./aider.nix
    ./foot.nix
    ./tmux.nix
  ];
  home.packages = with pkgs; [
    direnv
    neofetch
  ];
}
