{pkgs, ...}: {
  imports = [
    ./k9s.nix
    ./python.nix
    ./git.nix
    ./neovim.nix
    ./node.nix
    ./rust.nix
  ];
  home.packages = with pkgs; [
    libnvidia-container

    # Dev Apps
    ollama
    jetbrains.pycharm-professional
    postman
    jetbrains.rust-rover

    # Deps
    openssl.dev
    jdk21
    pkg-config
    protobuf
    lldb
    flatbuffers

    # CLI Tools
    lazydocker
    unzip
    zip
    edgedb
    wireshark-cli
    termshark
    htop
    spicedb-zed
    hetzner-k3s
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder

    # Infra
    kustomize
    kubectl
    kubernetes-helm
    helmfile
    minikube

    glab
  ];
}
