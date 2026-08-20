{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.terminal;
in {
  config = lib.mkIf cfg.opencode.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
      enableMcpIntegration = true;

      settings = {
        permission.external_directory."~/.cargo/registry/**" = "allow";
      };

      tui = {
        theme = "wal";
        leader_timeout = 1000;
        cursor = {
          style = "block";
          blinking = false;
        };
        attention = {
          enabled = true;
          notifications = true;
          sound = false;
        };
      };
    };

    xdg.configFile."opencode/AGENTS.md".source = ../../dotfiles/clankers/RULES.md;
  };
}
