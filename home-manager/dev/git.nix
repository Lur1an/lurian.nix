{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
  ];

  # programs.git = {
  #   enable = true;
  #   userName = "lur1an";
  #   userEmail = "lurian-code@protonmail.com";
  #   includes = [{path = "~/.config/git/localconf";}];
  # };

  # programs.gh = {
  #   enable = true;
  #   gitCredentialHelper.enable = true;
  # };
}
