{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./foot.nix
    ./tmux.nix
  ];
  home.packages = with pkgs; [
    direnv
    neofetch
  ];
}
