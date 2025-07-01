{pkgs, ...}: {
  home.packages = with pkgs; [
    aider-chat-full
  ];

  home.sessionVariables = {
    AIDER_AUTO_COMMITS = "false";
    OCO_AI_PROVIDER = "openai";
    OCO_API_URL = "https://openrouter.ai/api/v1";
    OCO_MODEL = "google/gemini-2.5-flash-lite-preview-06-17";
    OCO_DESCRIPTION = "false";
    OCO_EMOJI = "true";
    OCO_PROMPT_MODULE = "conventional-commit";
  };

  home.file.".aider.conf.yml".text = ''
    auto-commits: false
    dark-mode: true
    model: gemini2.5
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
  '';

  home.file.".aider.model.settings.yml".text = ''
    - name: openrouter/google/gemini-2.5-pro
      edit_format: diff-fenced
  '';
}
