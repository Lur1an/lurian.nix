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
    spicedb-zed
    nomachine-client
    libreoffice-qt
    htop
    jetbrains-toolbox
    qbittorrent
    glab
    easyeffects
    shell_gpt
    helmfile
    minikube
    kind
    kubernetes-helm
    kubectl
    k9s 
    openlens
    direnv
    edgedb
    neofetch
    networkmanagerapplet
    localstack
    gparted
    gnome.gnome-disk-utility
    extra_node_packages.aicommits
    act # github actions tester
    slurp
    grim
    ffmpeg
    nix-index
    openvpn
    openconnect
    pavucontrol
    unzip
    zip
  ];
}
