{
  pkgs,
  config,
  ...
}: let
  colors = config.colorscheme.colors;
in {
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        refreshRate = "2s";
        readOnly = true;
        logoless = true;
      };
    };
  };
}
