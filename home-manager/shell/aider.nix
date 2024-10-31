{pkgs, ...}: {
  home.packages = with pkgs; [
    aider-chat
  ];

  home.sessionVariables = {
    AIDER_AUTO_COMMITS = "false";
  };
}
