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
    bun
    dart-sass
    fd
    brightnessctl
    inputs.matugen.packages.${system}.default
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
    # configDir = ../../dotfiles/ags;
    extraPackages = with pkgs; [
      accountsservice
    ];
  };
}
