{
  inputs,
  pkgs,
  ...
}: 
let
  extra_node_packages = import ./node/default.nix { inherit pkgs; };
in 
{
  home.packages = with pkgs; [
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    barrier
    slack
    telegram-desktop
    inputs.self.packages.${system}.bazecor
    htop
    easyeffects
    neofetch
    networkmanagerapplet
    extra_node_packages.aicommits
    slurp
    grim
    ffmpeg
    nix-index
    openvpn
    openconnect
    pavucontrol
    playerctl
    unzip
  ];
}
