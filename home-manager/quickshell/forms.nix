{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lurian.quickshell.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "quickshell-form" ''
        export QUICKSHELL=${lib.getExe config.programs.quickshell.package}
        export SYSTEMCTL=${pkgs.systemd}/bin/systemctl
        exec ${pkgs.python3}/bin/python3 ${./scripts/form_client.py} "$@"
      '')
    ];
  };
}
