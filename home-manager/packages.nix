{
  pkgs,
  ...
}: 
let
  myFonts = pkgs.stdenv.mkDerivation {
    name = "myFonts";
    src = ../dotfiles/fonts;  # Replace with the path to your font files
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/fonts
      cp -r $src/* $out/share/fonts
    '';
  };
in
{
  home.packages = with pkgs; [
    firefox
    discord
    slack
    neovim
    tmux
    rustup
    telegram-desktop
    python311Full
    alacritty
    myFonts
  ];
}
