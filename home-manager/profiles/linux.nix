{
  outputs,
  pkgs,
  config,
  machineConfig,
  ...
}: {
  imports = [
    ../rice
    ../wal
    ../matugen
    ../wallpapers.nix
    ../fonts.nix
    ../terminal
    ../hyprland
    ../quickshell
    ../mimeapps.nix
    ../rofi
    ../k9s.nix
    ../python.nix
    ../node.nix
    ../rust.nix
    ../obs.nix
    ../firefox.nix
    ../neovim.nix
    ../minecraft.nix
  ];

  terminal = {
    code_font = "ComicCodeLigatures Nerd Font";
    ghostty.enable = true;
    opencode.enable = true;
    opencommit.enable = true;
  };

  # AI Widget sidebar
  quickshell = {
    enable = true;
    aiWidget.enable = true;
    autoStart = true;
  };

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

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs; [
    # Dev Apps
    postman
    # Deps
    git-lfs
    devenv
    accountsservice
    # CLI Tools
    fd
    wget
    git-repo
    neofetch
    lazygit
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
    fzf
    # Infra
    kustomize
    kubectl
    kubectl-cnpg
    kubernetes-helm
    minikube
    terraform
    packer
    # Misc
    google-chrome
    slack
    vdhcoapp
    discord
    betterdiscordctl
    signal-desktop
    remmina
    zoom-us
    spotify
    telegram-desktop
    obsidian
    loupe
    wallust
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
    nodePackages_latest.typescript-language-server
    nodePackages_latest.svelte-language-server
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
