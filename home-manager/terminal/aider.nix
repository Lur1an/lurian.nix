{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.terminal;
in {
  config = lib.mkIf cfg.aider.enable {
    home.packages = with pkgs; [
      aider-chat-full
    ];

    home.sessionVariables = {
      AIDER_AUTO_COMMITS = "false";
    };

    home.file.".aider.conf.yml".text = ''
      auto-commits: false
      dark-mode: true
      model: flash
      editor-model: sonnet
      thinking-tokens: 32000
      vim: true
      show-model-warnings: false
      alias:
      - deepseeklocal:ollama/deepseek-r1:32b
      - gemini2.5:openrouter/google/gemini-2.5-pro
      - sonnet:openrouter/anthropic/claude-sonnet-4
      - opus:openrouter/anthropic/claude-opus-4
      - o4-mini:openrouter/openai/o4-mini-high
      - grok:openrouter/x-ai/grok-4
      - flash:openrouter/google/gemini-2.5-flash
    '';

    home.file.".aider.model.settings.yml".text = ''
      - name: openrouter/google/gemini-2.5-pro
        edit_format: diff-fenced
    '';
  };
}
