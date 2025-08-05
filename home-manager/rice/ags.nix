{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    dart-sass
    fd
    brightnessctl
    asztal
    wf-recorder
    wayshot
    swappy
    hyprpicker
    networkmanager
    gtk3
  ];

  xdg.configFile.ags.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/dotfiles/ags";
  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      accountsservice
      # nodePackages.js-yaml
    ];
  };
}
