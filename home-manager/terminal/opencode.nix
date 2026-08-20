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

      extraPackages = with pkgs; [
        bash
        coreutils
        findutils
        git
        gnugrep
        gnused
        mcp-grafana
        nodejs
        playwright-mcp
        ripgrep
        uv
      ];

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

      agents = ../../dotfiles/opencode/agent;
      commands = ../../dotfiles/opencode/commands;
      skills = ../../dotfiles/opencode/skills;
    };
  };
}
