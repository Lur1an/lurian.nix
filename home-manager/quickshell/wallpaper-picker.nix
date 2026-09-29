{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.quickshell.wallpaperPicker;
  enabled = config.lurian.quickshell.enable && cfg.enable;
  scanner = pkgs.writeShellScript "scan-wallpapers" ''
    exec ${pkgs.python3}/bin/python3 ${./scripts/scan-wallpapers.py} "$@"
  '';
  launcher = pkgs.writeShellScriptBin "wallpaper-picker" ''
    set -eu
    # Serialize startup/toggles, including simultaneous key repeats.
    exec 9>"$XDG_RUNTIME_DIR/lurian-wallpaper-picker.lock"
    ${pkgs.util-linux}/bin/flock 9
    ${pkgs.systemd}/bin/systemctl --user start quickshell.service
    for _ in $(${pkgs.coreutils}/bin/seq 1 50); do
      if ${lib.getExe config.programs.quickshell.package} -c lurian ipc call wallpaperPicker ping >/dev/null 2>&1; then
        exec ${lib.getExe config.programs.quickshell.package} -c lurian ipc call wallpaperPicker toggle
      fi
      ${pkgs.coreutils}/bin/sleep 0.1
    done
    echo "Wallpaper picker did not become ready; check journalctl --user -u quickshell" >&2
    exit 1
  '';
in {
  options.lurian.quickshell.wallpaperPicker = {
    enable = lib.mkEnableOption "the floating wallpaper picker";
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional media directories, scanned recursively alongside ~/wallpapers.";
    };
    keybind = lib.mkOption {
      type = lib.types.str;
      default = "SUPER + V";
      description = "Hyprland binding to toggle the picker.";
    };
    previewDelayMs = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 120;
      description = "Debounce delay before loading the selected preview.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.lurian.quickshell.enable {
      xdg.configFile."quickshell/lurian/picker-settings.json".text = builtins.toJSON {
        inherit enabled;
        inherit (cfg) previewDelayMs;
        directories = lib.unique (["${config.home.homeDirectory}/wallpapers"] ++ cfg.directories);
        scanCommand = "${scanner}";
        applyCommand = lib.getExe config.lurian.wallpapers.package;
      };
    })
    (lib.mkIf enabled {
      home.packages = [launcher];
      hyprdesktop.extraBinds = [
        {
          keys = cfg.keybind;
          command = lib.getExe launcher;
        }
      ];
    })
  ];
}
