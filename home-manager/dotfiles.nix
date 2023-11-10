{
  config,
  pkgs,
  ...
}: 
let
  dotfiles = "../dotfiles";
in
{
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
}

