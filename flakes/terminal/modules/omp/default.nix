{inputs, ...}: {
  config.terminal.homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.lurian.terminal;
    package = inputs.omp.packages.${pkgs.stdenv.hostPlatform.system}.default;
    undoRedo = pkgs.callPackage ./undo-redo.pkg.nix {};
    yamlFormat = pkgs.formats.yaml {};
  in {
    imports = [inputs.omp.homeManagerModules.default];
    config = lib.mkIf cfg.omp.enable {
      programs.omp = {
        enable = true;
        inherit package;
        settings = {
          providers.webSearchOrder = [
            "ecosia"
            "perplexity"
            "gemini"
            "anthropic"
            "codex"
            "xai"
            "zai"
            "exa"
            "tinyfish"
            "jina"
            "kagi"
            "tavily"
            "firecrawl"
            "brave"
            "kimi"
            "parallel"
            "synthetic"
            "searxng"
            "startpage"
            "duckduckgo"
            "google"
            "mojeek"
            "public"
          ];
          modelRoles = {
            default = "openai-codex/gpt-5.6-sol:low";
            smol = "openai-codex/gpt-5.6-terra:medium";
            slow = "openai-codex/gpt-5.6-sol:max";
            tiny = "openai-codex/gpt-5.6-luna";
            cheap = "opencode-go/ox-alpha-free";
          };
          disabledProviders = [
            "lm-studio"
            "llama.cpp"
          ];
          symbolPreset = "nerd";
          setupVersion = 1;
          defaultThinkingLevel = "auto";
          cycleOrder = [
            "default"
            "smol"
            "slow"
            "tiny"
            "cheap"
          ];
          task.agentModelOverrides.sonic = "openai-codex/gpt-5.6-luna";
          startup = {
            quiet = true;
            setupWizard = false;
            checkUpdate = false;
          };
          tier.openai = "priority";
          browser.headless = true;
        };
      };

      home.file.".omp/agent/keybindings.yml".source = yamlFormat.generate "omp-keybindings.yml" {
        "tui.editor.cursorLeft" = ["Left" "Ctrl+B" "Alt+H"];
        "tui.editor.cursorDown" = ["Down" "Alt+J"];
        "tui.editor.cursorUp" = ["Up" "Alt+K"];
        "tui.editor.cursorRight" = ["Right" "Ctrl+F" "Alt+L"];
        "tui.editor.cursorWordLeft" = ["Alt+Left" "Ctrl+Left" "Alt+B"];
        "tui.editor.cursorWordRight" = ["Alt+Right" "Ctrl+Right" "Alt+F" "Alt+W"];
        "tui.editor.deleteCharForward" = ["Delete" "Ctrl+D" "Alt+X"];
        "tui.editor.undo" = ["Ctrl+-" "Ctrl+_" "Alt+U"];
        "tui.select.up" = ["Up" "Ctrl+P"];
        "tui.select.down" = ["Down" "Ctrl+N"];
        "app.model.cycleForward" = "Alt+P";
        "app.model.selectTemporary" = [];
        "app.display.reset" = "Alt+Shift+L";
      };

      home.file.".omp/agent/RULES.md".source = ../agents/RULES.md;

      # Ambient OMP extension: /undo and /redo session navigation.
      # https://github.com/Baylar55/omp-undo-redo
      home.file.".omp/agent/extensions/omp-undo-redo".source =
        undoRedo + "/lib/omp-undo-redo";
      programs.omp.settings.theme = lib.mkIf cfg.wal.enable {
        dark = "wal";
        light = "light";
      };
      lurian.terminal.wal.templates = lib.mkIf cfg.wal.enable {
        "omp-wal.json" = ./wal.json;
      };
      home.file.".omp/agent/themes/wal.json".source =
        lib.mkIf cfg.wal.enable (cfg.wal.linkWal "omp-wal.json");
    };
  };
}
