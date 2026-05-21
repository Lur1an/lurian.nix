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
      opencode
      # opencode
      playwright-mcp
    ];
    xdg.configFile."opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/opencode";
  };
}
