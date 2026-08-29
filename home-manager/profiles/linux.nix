{
  pkgs,
  config,
  machineConfig,
  inputs,
  ...
}: {
  imports = [
    ../rice
    inputs.terminal.homeModules.default
    ../wallpapers.nix
    ../fonts.nix
    ../terminal
    ../hyprland
    ../mimeapps.nix
    ../git.nix
    ../rofi
    ../waybar
    ../k9s
    ../python.nix
    ../node.nix
    ../rust.nix
    ../obs.nix
    ../firefox
    ../minecraft.nix
  ];

  lurian.terminal = {
    codeFont = "ComicCodeLigatures Nerd Font";
    neovim.enable = true;
    wal.enable = true;
    matugen.enable = true;
    ghostty.enable = true;
    tmux.enable = true;
    opencode.enable = true;
    zsh.enable = true;
    omp.enable = true;
    lazygit.enable = true;
    opencommit.enable = true;
    zshAi.enable = true;
  };

  programs.zsh.shellAliases.update = "find ~/.config -name '*hm-bak' -delete && find ~/.mozilla -name '*hm-bak' -delete && sudo nixos-rebuild switch --flake";

  rust = {
    debugger.enable = true;
    slim = false;
  };

  gtk.gtk3.bookmarks = let
    home = config.home.homeDirectory;
  in
    [
      "file://${home}/Documents"
      "file://${home}/Downloads"
      "file://${home}/Pictures"
      "file://${home}/wallpapers"
      "file://${home}/Videos"
    ]
    ++ machineConfig.bookmarks;

  home.packages = with pkgs; [
    # Dev Apps
    postman
    # Deps
    protobuf
    devenv
    accountsservice
    # CLI Tools
    net-tools
    proton-pass-cli
    proton-pass
    fd
    wget
    git-repo
    fastfetch
    tree
    postgresql
    cloudflared
    eza
    xca
    kubeseal
    lazydocker
    minicom
    unzip
    zip
    wireguard-tools
    htop
    argocd
    jq
    yq-go
    # Infra
    kustomize
    kubectl
    kubectl-cnpg
    kubernetes-helm
    minikube
    terraform
    packer
    ansible
    # Misc
    google-chrome
    brave
    surrealist
    element-desktop
    slack
    discord
    vesktop
    signal-desktop
    remmina
    zoom-us
    spotify
    telegram-desktop
    obsidian
    loupe
    wallust
    mcp-grafana
    evince
    nautilus
    # Gnome
    libreoffice-qt
    networkmanagerapplet
    lsof
    gnome-disk-utility
    gnome-bluetooth
    ffmpeg
    nix-index
    pavucontrol
    # LanguageServers
    lua-language-server
    terraform-ls
    helm-ls
    yamlfix
    yaml-language-server
    tailwindcss-language-server
    basedpyright
    docker-compose-language-service
    dockerfile-language-server
    isort
    nixd
    just-lsp
    stylua
    marksman
    typescript-language-server
    svelte-language-server
    graphql-language-service-cli
  ];

  home.username = "lurian";
  home.homeDirectory = "/home/lurian";
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "foot";
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
