{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.quickshell;
  # Add runtime QML/codecs without rebuilding Quickshell itself.
  package = pkgs.symlinkJoin {
    name = "quickshell-with-media";
    paths = [pkgs.quickshell];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/quickshell" \
        --prefix QML_IMPORT_PATH : "${pkgs.qt6.qtmultimedia}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
        --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtmultimedia}/${pkgs.qt6.qtbase.qtPluginPrefix}:${pkgs.qt6.qtimageformats}/${pkgs.qt6.qtbase.qtPluginPrefix}"
    '';
    meta.mainProgram = "quickshell";
  };
in {
  imports = [./wallpaper-picker.nix];

  options.lurian.quickshell.enable = lib.mkEnableOption "the Lurian Quickshell components";

  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      inherit package;
      activeConfig = "lurian";
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
    };

    systemd.user.services.quickshell = {
      Unit = {
        PartOf = ["hyprland-session.target"];
        X-Restart-Triggers = [
          "${./qml}"
          config.xdg.configFile."quickshell/lurian/picker-settings.json".source
          config.xdg.configFile."quickshell/lurian/theme-settings.json".source
        ];
      };
      Service = {
        RestartSec = 1;
        Environment = ["QT_QUICK_CONTROLS_STYLE=Basic"];
      };
    };

    xdg.configFile = {
      "quickshell/lurian" = {
        source = ./qml;
        recursive = true;
      };
      "quickshell/lurian/theme-settings.json".text = builtins.toJSON {
        palettePath =
          if config.lurian.terminal.matugen.enable
          then "${config.xdg.cacheHome}/matugen/quickshell-colors.json"
          else "";
      };
      "matugen/templates/quickshell-colors.json" = lib.mkIf config.lurian.terminal.matugen.enable {
        source = ./templates/colors.json;
      };
    };

    lurian.terminal.matugen.templates = lib.mkIf config.lurian.terminal.matugen.enable {
      quickshell-colors = {
        input_path = "${config.xdg.configHome}/matugen/templates/quickshell-colors.json";
        output_path = "${config.xdg.cacheHome}/matugen/quickshell-colors.json";
      };
    };
  };
}
