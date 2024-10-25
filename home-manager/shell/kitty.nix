{pkgs, custom, ...}: let
in {
  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = {
    enable = true;
    font.name = custom.code_font;
    settings = {
      font_size = 12;
      background_opacity = 0.85;
      window_padding_width = 10;
    };
    extraConfig = ''
      include colors.conf
    '';
  };
}
