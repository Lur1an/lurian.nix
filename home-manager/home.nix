# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  custom = {
    code_font = "ComicCodeLigatures Nerd Font";
    font = "ComicCodeLigatures Nerd Font";
  };
in {
  _module.args = {inherit custom;};
  imports = [
    ./zsh.nix
    ./chrome.nix
    ./dev.nix
    ./rofi.nix
    ./themes
    ./minecraft.nix
    ./wallpapers.nix
    ./firefox.nix
    ./thunar.nix
    ./obs.nix
    ./fonts.nix
    ./neovim.nix
    ./packages.nix
    ./tmux.nix
    ./discord.nix
    ./alacritty.nix
    ./hyprland
    # ./i3
  ];

  # wallpaper
  xdg.configFile."wallpaper/wallpaper.png".source = ../wallpapers/mistery_dungeon.png;

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
    TERMINAL = "alacritty";
  };

  programs.home-manager.enable = true;

  # programs.git = {
  #   enable = true;
  #   userName = "lur1an";
  #   userEmail = "lurian-code@protonmail.com";
  #   includes = [{path = "~/.config/git/localconf";}];
  # };

  # programs.gh = {
  #   enable = true;
  #   gitCredentialHelper.enable = true;
  # };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "text/csv" = "scalc.desktop";
      "application/pdf" = ["evince.desktop"];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
