{pkgs, ...}: {
  home = {
    sessionVariables.BROWSER = "firefox";
  };

  programs.librewolf = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta;
  };
}
