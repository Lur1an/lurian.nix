{pkgs, ...}: {
  home.packages = with pkgs; [
    aider-chat.withPlaywright
  ];

  home.sessionVariables = {
    AIDER_AUTO_COMMITS = "false";
  };

  home.file.".aider.conf.yml".text = ''
    auto-commits: false
    dark-mode: true
    model: openrouter/anthropic/claude-3.7-sonnet
    editor-model: openrouter/anthropic/claude-3.7-sonnet
    vim: true
    alias:
    - deepseeklocal:ollama/deepseek-r1:32b
  '';
}
