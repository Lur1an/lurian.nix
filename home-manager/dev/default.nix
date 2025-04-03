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
    postman
    jetbrains.rust-rover
    beekeeper-studio

    # Deps
    openssl
    openssl.dev
    jdk21
    git-lfs
    devenv
    protobuf
    lldb
    buf

    # CLI Tools
    nxpmicro-mfgtools
    eza
    minio-client
    git-repo
    appimage-run
    xca
    oha
    git-crypt
    k3sup
    kubeseal
    kubectl-cnpg
    rover
    drill
    curl-impersonate
    lazydocker
    minicom
    actionlint
    unzip
    gh-markdown-preview
    zip
    sc-im
    gel
    wireshark-cli
    talosctl
    wireguard-tools
    termshark
    htop
    argocd
    spicedb-zed
    hetzner-k3s
    sqlite
    postgresql
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
