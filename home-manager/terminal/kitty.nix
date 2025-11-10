{
  config,
  lib,
  ...
}: let
  cfg = config.terminal;
in {
  config = lib.mkIf (builtins.elem "kitty" cfg.flavours) {
    programs.kitty = {
      enable = true;
      font.name = cfg.code_font;
      settings = {
        font_size = 12;
        background_opacity = 0.85;
        confirm_os_window_close = 0;
        window_padding_width = 10;
        input_delay = 0;
        repaint_delay = 2;
        sync_to_monitor = false;
        wayland_enable_ime = false;
      };
      extraConfig = ''
        include ${config.home.homeDirectory}/.cache/wal/colors-kitty.conf
      '';
    };
  };
}
