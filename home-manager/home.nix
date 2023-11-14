# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./dotfiles.nix
    ./firefox.nix
    ./fonts.nix
    ./neovim.nix
    ./packages.nix
    ./gtk.nix
    ./tmux.nix
    ./foot.nix
    ./discord.nix
    ./alacritty.nix
    ./i3
  ];

  # wallpaper
  xdg.configFile."wallpaper/wallpaper.png".source  = ../wallpapers/mistery_dungeon.png;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # (self: super: {
      #   discord = super.discord.overrideAttrs (
      #     _: {
      #       src = builtins.fetchTarball {
      #         url = "https://discord.com/api/download?platform=linux&format=tar.gz";
      #       };
      #     }
      #   );
      # })
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
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

  programs.git = {
    enable = true;
    userName  = "lur1an";
    userEmail = "lurian-code@protonmail.com";
    includes = [{ path = "~/.config/git/localconf"; }];
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
