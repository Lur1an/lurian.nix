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
    alias:
    - deepseeklocal:ollama/deepseek-r1:32b
    - gemini2.5:openrouter/google/gemini-2.5-pro-preview
    - claude3.7:openrouter/anthropic/claude-3.7-sonnet
    show-model-warnings: false
  '';

  home.file.".aider.model.settings.yml".text = ''
  - name: openrouter/google/gemini-2.5-pro-preview
    edit_format: diff-fenced
    extra_params:
      reasoning_effort: 0.0
      thinking_tokens: 0
  '';
}
