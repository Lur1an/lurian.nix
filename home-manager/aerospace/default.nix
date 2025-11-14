{config, ...}: {
  programs.aerospace = {
    enable = true;
  };
  xdg.configFile."aerospace/aerospace.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/home-manager/aerospace/aerospace.toml";
}
