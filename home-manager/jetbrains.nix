{config, ...}: {
  home.file.".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/.ideavimrc";
}
