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
    postman
    jetbrains.rust-rover

    # Deps
    openssl
    openssl.dev
    git-lfs
    devenv
    protobuf

    # CLI Tools
    opencommit
    difftastic
    terraform
    packer
    claude-code
    tree
    nxpmicro-mfgtools
    cloudflared
    eza
    git-repo
    xca
    oha
    hcloud
    git-crypt
    k3sup
    kubectl-cnpg
    kubeseal
    rover
    curl-impersonate
    lazydocker
    minicom
    unzip
    zip
    sc-im
    gel
    wireguard-tools
    htop
    argocd
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
    minikube
  ];
}
