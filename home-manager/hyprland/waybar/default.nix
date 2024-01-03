{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  custom,
  machineConfig,
  ...
}:
with lib; let
  waybar_config = import ./config.nix {inherit osConfig config lib pkgs machineConfig;};
  waybar_style = import ./style.nix {inherit config custom;};
in {
  home.packages = with pkgs; [
    playerctl
    cava
    (python311Full.withPackages (ps:
      with ps; [
        pip
        requests
        pygobject3 # Python bindings for Glib
        gst-python # Python bindings for GStreamer
      ]))
  ];
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    });
    settings = waybar_config;
    style = waybar_style;
  };
}
