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
    editor-model: claude-3-5-sonnet-20241022
    alias:
    - deepseeklocal:ollama/deepseek-r1:32b
  '';
}
