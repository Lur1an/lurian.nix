
{
  pkgs,
  ...
}: 
let
  dotfiles = pkgs.stdenv.mkDerivation {
    name = "dotfiles";
    src = pkgs.fetchgit {
      url = "https://github.com/lur1an/dotfiles";
    };
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in
{
  home.file.".config/nvim".source = "${dotfiles}/nvim";
}

