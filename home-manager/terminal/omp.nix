{
  config,
  inputs,
  pkgs,
  ...
}: let
  package = pkgs.symlinkJoin {
    name = "omp";
    paths = [inputs.omp.packages.${pkgs.stdenv.hostPlatform.system}.default];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/omp \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib]}
    '';
  };
  yamlFormat = pkgs.formats.yaml {};
in {
  imports = [inputs.omp.homeManagerModules.default];

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
      theme = {
        dark = "wal";
        light = "light";
      };
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
      stt = {
        enabled = true;
        submitTrigger = "never";
      };
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
    "app.stt.toggle" = "Alt+S";
  };

  home.file.".omp/agent/mcp.json".source = config.xdg.configFile."mcp/mcp.json".source;
  home.file.".omp/agent/RULES.md".source = ../../dotfiles/clankers/RULES.md;

  # Ambient OMP extension: /undo and /redo session navigation.
  # https://github.com/Baylar55/omp-undo-redo
  home.file.".omp/agent/extensions/omp-undo-redo".source =
    pkgs.omp-undo-redo + "/lib/omp-undo-redo";
}
