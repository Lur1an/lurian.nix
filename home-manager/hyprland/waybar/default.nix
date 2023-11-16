{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}:
with lib; let
  waybar_config = import ./config.nix {inherit osConfig config lib pkgs;};
  waybar_style = import ./style.nix {inherit (config) colorscheme;};
in {
  home.packages = with pkgs; [
    cava
    (python311Full.withPackages (ps:
      with ps; [
        pip
        pygobject3 # Python bindings for Glib
        gst-python # Python bindings for GStreamer
      ]))
  ];
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    settings = waybar_config;
    style = waybar_style;
  };
}
