{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    opencode
  ];
  xdg.configFile."opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/opencode";
}
