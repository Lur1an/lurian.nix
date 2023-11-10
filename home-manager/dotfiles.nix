
{
  pkgs,
  fetchgit,
  ...
}: {
  ".config/nvim".source = fetchgit {
     url = "https://github.com/lur1an/dotfiles";
     sparsecheckout = [ "nvim" ];
  };
}
