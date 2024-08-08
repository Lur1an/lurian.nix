{
  inputs,
  pkgs,
  ...
}: let
in {
  home.packages = with pkgs; [
    sea-orm-cli
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    kustomize
    sqlite
    hetzner-k3s
    postman
    slack
    remmina
    telegram-desktop
    edgedb
    obsidian
    nautilus
    gthumb
    gnome-desktop
    ffmpegthumbnailer
    libreoffice-qt
    spacedrive
    htop
    qbittorrent
    evince
    spicedb-zed
    postgresql
    jetbrains-toolbox
    glab
    helmfile
    minikube
    kubectl
    direnv
    neofetch
    networkmanagerapplet
    gparted
    gnome-disk-utility
    slurp
    grim
    ffmpeg
    nix-index
    openvpn
    pavucontrol
    unzip
    zip
  ];
}
