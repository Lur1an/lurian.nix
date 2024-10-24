{pkgs, ...}: {
  imports = [
    ./hypr
  ];
  home.packages = with pkgs; [
    slurp
    grim
  ];
}
