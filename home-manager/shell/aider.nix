{pkgs, ...}: {
  home.packages = with pkgs; [
    aider-chat.withPlaywright
  ];

  home.sessionVariables = {
    AIDER_AUTO_COMMITS = "false";
  };
}
