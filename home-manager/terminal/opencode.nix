{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.terminal;
  superpowers = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v6.3.0";
    hash = "sha256-EsGNO0dULWf5Bx6bGrCv2kI2Z8aKH0kRvGiuN23wChQ=";
  };
in {
  config = lib.mkIf cfg.opencode.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
      enableMcpIntegration = true;

      settings = {
        permission.external_directory."~/.cargo/registry/**" = "allow";
        plugin = ["file://${superpowers}/.opencode/plugins/superpowers.js"];
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
