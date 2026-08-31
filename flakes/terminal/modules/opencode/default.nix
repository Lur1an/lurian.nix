{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.terminal;
  superpowers = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v6.3.0";
    hash = "sha256-EsGNO0dULWf5Bx6bGrCv2kI2Z8aKH0kRvGiuN23wChQ=";
  };
in {
  config = lib.mkIf cfg.opencode.enable (lib.mkMerge [
    {
      programs.opencode = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          permission = {
            external_directory."~/.cargo/registry/**" = "allow";
            bash = {
              "*" = "allow";
              kubectl = "ask";
              "kubectl *" = "ask";
              terraform = "ask";
              "terraform *" = "ask";
            };
          };
          provider.zai-coding-plan.options.timeout = 600000;
          plugin = ["file://${superpowers}/.opencode/plugins/superpowers.js"];
        };
        tui =
          {
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
          }
          // lib.optionalAttrs cfg.wal.enable {theme = "wal";};
      };
      xdg.configFile."opencode/AGENTS.md".source = ../agents/RULES.md;
    }
    (lib.mkIf cfg.wal.enable {
      lurian.terminal.wal.templates."opencode-wal.json" = ./wal.json;
      xdg.configFile."opencode/themes/wal.json".source = cfg.wal.linkWal "opencode-wal.json";
    })
  ]);
}
