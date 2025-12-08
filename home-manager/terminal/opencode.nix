{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.terminal;
in {
  config = lib.mkIf cfg.opencode.enable {
    home.packages = with pkgs; [
      inputs.opencode.packages.${pkgs.system}.default
      playwright-mcp
      playwright
    ];
    home.sessionVariables = {
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright.browsers}";
    };
    xdg.configFile."opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/opencode";
  };
}
