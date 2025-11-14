{config, pkgs, ...}: {
  # programs.aerospace = {
  #   enable = true;
  # };
  home.packages = with pkgs; [
    aerospace
  ];
  xdg.configFile."aerospace/aerospace.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/home-manager/aerospace/aerospace.toml";
}
