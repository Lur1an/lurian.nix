{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font.name = "ComicCodeLigatures Nerd Font";
    settings = {
      window_padding_width = 5;
      background_opacity = "0.7";
      background_blur = 0;
      font_size = 12;
      placement_strategy = "top-left";
      text_composition_strategy = "legacy";
    };
    theme = "Catppuccin-Frappe";
  };
}
