{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.terminal;
in {
  config = lib.mkIf cfg.opencode.enable (lib.mkMerge [
    {
      programs.opencode = {
        enable = true;
        package = lib.mkDefault (pkgs.callPackage ./package.nix {});
        # Home Manager emits supported V1 MCP entries; V2 normalizes them.
        enableMcpIntegration = true;
        settings = {
          update = "disable";
          permissions =
            [
              {
                action = "external_directory";
                resource = "~/.cargo/registry/**";
                effect = "allow";
              }
              {
                action = "external_directory";
                resource = "~/.cargo/git/**";
                effect = "allow";
              }
              {
                action = "external_directory";
                resource = "*/.treehouse/**";
                effect = "allow";
              }
              {
                action = "external_directory";
                resource = "*/treehouse/**";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "*";
                effect = "allow";
              }
            ]
            ++ map (resource: {
              action = "shell";
              inherit resource;
              effect = "ask";
            }) ["kubectl" "kubectl *" "terraform" "terraform *"];
          providers.zai-coding-plan.settings.timeout = 600000;
        };
      };
      xdg.configFile."opencode/cli.json".text = builtins.toJSON (
        {
          "$schema" = "https://opencode.ai/v2/cli.json";
          leader.timeout = 1000;
          keybinds = {
            "prompt.editor" = "ctrl+e";
            "input.line.end" = false;
            "session.tab.next" = "tab,ctrl+tab,alt+down";
            "session.tab.close" = "ctrl+q";
            "prompt.autocomplete.complete" = false;
          };
          cursor = {
            style = "block";
            blinking = false;
          };
          attention = {
            notifications = true;
            sound = false;
          };
        }
        // lib.optionalAttrs cfg.wal.enable {theme.name = "wal";}
      );
      xdg.configFile."opencode/AGENTS.md".source = cfg.agents_md_path;
      xdg.configFile."opencode/skills" = lib.mkIf (cfg.skills != null) {
        source = cfg.skills;
        recursive = true;
      };
    }
    (lib.mkIf cfg.wal.enable {
      lurian.terminal.wal.templates."opencode-wal.json" = ./wal.json;
      xdg.configFile."opencode/themes/wal.json".source = cfg.wal.linkWal "opencode-wal.json";
    })
  ]);
}
