{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    fuzzel
  ];
}
