{
  config,
  pkgs,
  ...
}: 
let
  dotfiles = "../dotfiles";
in
{
  xdg.configFile.nvim.source = "${dotfiles}/nvim";
}

