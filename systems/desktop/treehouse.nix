{
  config,
  lib,
  ...
}: let
  cfg = config.home-manager.users.lurian.lurian.terminal.treehouse;
in {
  systemd.tmpfiles.rules = lib.optionals cfg.enable [
    "d ${cfg.root}/.treehouse 0750 lurian users - -"
  ];
}
