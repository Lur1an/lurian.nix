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
  ];

  home.packages = with pkgs; [
    xclip
  ];

}
