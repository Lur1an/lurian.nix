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
    - gemini2.5:openrouter/google/gemini-2.5-pro-preview-03-25
    - claude3.7:openrouter/anthropic/claude-3.7-sonnet
    show-model-warnings: false
  '';
}
