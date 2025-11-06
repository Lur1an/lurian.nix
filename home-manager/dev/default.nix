{pkgs, ...}: {
  imports = [
    ./k9s.nix
    ./python.nix
    ./neovim.nix
    ./node.nix
    ./rust.nix
  ];
  home.packages = with pkgs; [
    # Dev Apps
    postman

    # Deps
    git-lfs
    devenv

    # CLI Tools
    opencommit
    lazygit
    tree
    postgresql
    cloudflared
    eza
    xca
    kubectl-cnpg
    kubeseal
    lazydocker
    minicom
    unzip
    zip
    wireguard-tools
    htop
    argocd
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    # Infra
    kustomize
    kubectl
    kubernetes-helm
    minikube
    terraform
    packer
  ];
}
