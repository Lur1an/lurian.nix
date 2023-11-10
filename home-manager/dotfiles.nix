
{
  config,
  pkgs,
  ...
}: 
let
  dotfiles = "../dotfiles";
in
{
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
  };
}

