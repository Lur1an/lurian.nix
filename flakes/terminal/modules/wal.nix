{...}: {
  config.terminal.homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.lurian.terminal.wal;
  in {
    config = lib.mkMerge [
      {
        lurian.terminal.wal.linkWal = fileName:
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/wal/${fileName}";
      }
      (lib.mkIf cfg.enable {
        home.packages = [pkgs.pywal16 pkgs.imagemagick];
        xdg.configFile = lib.mapAttrs' (name: source:
          lib.nameValuePair "wal/templates/${name}" {inherit source;})
        cfg.templates;
      })
    ];
  };
}
