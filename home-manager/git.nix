{
  home.file.".gitconfig".text = ''
    # Managed by Home Manager in ~/.config/git/config.
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "lur1an";
        email = "lurian-code@protonmail.com";
      };

      color.ui = "auto";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      aliases.co = "pr checkout";
      git_protocol = "https";
      prompt = "enabled";
    };
    gitCredentialHelper.enable = true;
  };
}
