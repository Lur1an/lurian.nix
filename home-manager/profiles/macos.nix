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
    ghostty = {
      enable = true;
      package = null;
    };
  };

  home.stateVersion = "25.05";
}
