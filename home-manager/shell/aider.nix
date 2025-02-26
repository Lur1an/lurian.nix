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
    model: claude-3-7-sonnet-20250219
    editor-model: claude-3-7-sonnet-20250219
    vim: true
    alias:
    - deepseeklocal:ollama/deepseek-r1:32b
  '';
}
