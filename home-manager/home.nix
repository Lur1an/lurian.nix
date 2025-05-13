# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  inputs,
  config,
  machineConfig,
  ...
}: let
  custom = {
    code_font = "ComicCodeLigatures Nerd Font";
    font = "ComicCodeLigatures Nerd Font";
  };
in {
  _module.args = {inherit custom;};
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./rice
    ./shell
    ./wal
    ./wallpapers.nix
    ./fonts.nix
    ./packages.nix
    ./hyprland
    ./mimeapps.nix
    ./dev
    ./programs
  ];

  gtk.gtk3.bookmarks = let
    home = config.home.homeDirectory;
  in
    [
      "file://${home}/Documents"
      "file://${home}/Downloads"
      "file://${home}/Pictures"
      "file://${home}/wallpapers"
      "file://${home}/Videos"
    ]
    ++ machineConfig.bookmarks;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.username = "lurian";
  home.homeDirectory = "/home/lurian";
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "foot";
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
