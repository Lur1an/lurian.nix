{
  pkgs,
  config,
  ...
}: let
  linkWal = f: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/wal/${f}";
in {
  home.packages = with pkgs; [
    pywal16
    imagemagick
  ];
  xdg.configFile."wal/templates".source = ./templates;
  xdg.configFile."opencode/themes/wal.json".source = linkWal "opencode-wal.json";
  home.file.".omp/agent/themes/wal.json".source = linkWal "omp-wal.json";
  home.file."lurian.nix/dotfiles/nvim/lua/themes/wal-dark.lua".source = linkWal "wal-dark.lua";
  home.file."lurian.nix/dotfiles/nvim/lua/themes/wal-light.lua".source = linkWal "wal-light.lua";
}
