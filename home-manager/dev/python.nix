{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    poetry
    pre-commit
  ];
}
