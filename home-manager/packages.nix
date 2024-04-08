{
  inputs,
  pkgs,
  ...
}: let
  extra_node_packages = import ./node/default.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    filezilla
    kustomize
    openlens
    fluxcd
    sqlite
    go-task
    postman
    slack
    argocd
    remmina
    telegram-desktop
    motrix
    obsidian
    gnome.nautilus
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
    easyeffects
    helmfile
    minikube
    kubectl
    direnv
    edgedb
    neofetch
    networkmanagerapplet
    gparted
    gnome.gnome-disk-utility
    extra_node_packages.aicommits
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
