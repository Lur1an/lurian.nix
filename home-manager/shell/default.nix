{pkgs, ...}: {
  imports = [
    # ./kitty.nix
    ./aider.nix
    # ./foot.nix
    # ./tmux
    # ./ghostty.nix
    # ./opencode.nix
  ];
  home.packages = with pkgs; [
    direnv
    neofetch
  ];
}
