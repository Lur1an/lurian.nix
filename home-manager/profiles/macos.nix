{...}: {
  imports = [
    ../terminal
    ../fonts.nix
    ../wal
    ../matugen
    ../rust.nix
    ../wallpapers.nix
    ../neovim.nix
    ../aerospace.nix
    ../karabiner.nix
  ];

  terminal = {
    code_font = "ComicCodeLigatures Nerd Font";
    flavours = ["ghostty"];
  };

  home.stateVersion = "25.05";
}
