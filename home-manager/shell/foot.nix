{config, ...}: let
in {
  programs.foot = {
    enable = true;
    server.enable = true;
  };
  xdg.configFile.foot.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/foot";
}
