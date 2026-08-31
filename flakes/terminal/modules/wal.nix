{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.terminal.wal;
  legacyTemplates = "${config.xdg.configHome}/wal/templates";
in {
  config = lib.mkMerge [
    {
      lurian.terminal.wal.linkWal = fileName:
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/wal/${fileName}";
    }
    (lib.mkIf cfg.enable {
      home.packages = [pkgs.pywal16 pkgs.imagemagick];
      # Older revisions managed the whole templates directory as one store
      # symlink. Remove that parent link before Home Manager creates per-file
      # links; otherwise it tries to modify the read-only store directory.
      home.activation.removeLegacyWalTemplates =
        lib.hm.dag.entryBefore ["checkLinkTargets"] ''
          if [[ -L ${lib.escapeShellArg legacyTemplates} ]]; then
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/rm -f -- ${lib.escapeShellArg legacyTemplates}
          fi
        '';
      xdg.configFile = lib.mapAttrs' (name: source:
        lib.nameValuePair "wal/templates/${name}" {inherit source;})
      cfg.templates;
    })
  ];
}
