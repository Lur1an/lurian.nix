{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    ollama
    pywal
    sassc
  ];

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  xdg.configFile.ags.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/ags";
  programs.ags = {
    enable = true;
    configDir = null; # if ags dir is managed by home-manager, it'll end up being read-only. not too cool.
    # configDir = ./.config/ags;

    extraPackages = with pkgs; [
      gtksourceview
      gtksourceview4
      pywal
      sassc
      webkitgtk
      webp-pixbuf-loader
      ydotool
    ];
  };
}
