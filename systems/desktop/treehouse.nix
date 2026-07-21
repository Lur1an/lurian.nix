{config, ...}: let
  cfg = config.home-manager.users.lurian.treehouseConfig;
in {
  # The pool must live on the mounted HDD rather than the root filesystem.
  systemd.tmpfiles.rules = ["d ${cfg.root}/.treehouse 0750 lurian users - -"];
}
