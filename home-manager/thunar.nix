{pkgs, ...}: {
  home.packages = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
}
