{pkgs, ...}: {
  home.packages = with pkgs; [
    aider-chat-full
  ];

  home.sessionVariables = {
    AIDER_AUTO_COMMITS = "false";
  };

  home.file.".aider.conf.yml".text = ''
    auto-commits: false
    dark-mode: true
    model: gemini2.5
    editor-model: gemini2.5
    vim: true
    show-model-warnings: false
    alias:
    - deepseeklocal:ollama/deepseek-r1:32b
    - gemini2.5:openrouter/google/gemini-2.5-pro-preview
    - sonnet:openrouter/anthropic/claude-sonnet-4
    - opus:openrouter/anthropic/claude-opus-4
    - o4-mini:openrouter/openai/o4-mini-high
  '';

  home.file.".aider.model.settings.yml".text = ''
    - name: openrouter/google/gemini-2.5-pro-preview
      edit_format: diff-fenced
      extra_params:
        reasoning_effort: 0.0
        thinking_tokens: 0
  '';
}
