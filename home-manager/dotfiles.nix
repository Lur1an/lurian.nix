
{
  pkgs,
  ...
}: {
  ".config/nvim".source = pkgs.fetchgit {
     url = "https://github.com/lur1an/dotfiles";
     sparseCheckout = [ "nvim" ];
  };
}
