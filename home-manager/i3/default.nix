{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./i3.nix
    ./gtk.nix
  ];

  home.packages = with pkgs; [
    xclip
  ];
}
