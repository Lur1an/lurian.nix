{
  pkgs,
  config,
  ...
}: let
  colors = config.colorscheme.palette;
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
