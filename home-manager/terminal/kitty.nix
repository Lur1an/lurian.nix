{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.terminal;
in {
  options.lurian.terminal.kitty = {
    enable = lib.mkEnableOption "Kitty terminal";
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.kitty;
      description = "Kitty package to use";
    };
  };
  config = lib.mkIf cfg.kitty.enable {
    programs.kitty = {
      enable = true;
      package = cfg.kitty.package;
      font.name = cfg.codeFont;
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
      extraConfig = lib.optionalString cfg.wal.enable ''
        include ${config.home.homeDirectory}/.cache/wal/colors-kitty.conf
      '';
    };
  };
}
