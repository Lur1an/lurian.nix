{...}: {
  imports = [
    ../terminal.nix
    ../fonts.nix
  ];

  terminal = {
    code_font = "ComicCodeLigatures Nerd Font";
    flavours = ["ghostty"];
  };
}
