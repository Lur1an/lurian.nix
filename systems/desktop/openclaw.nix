{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    openclaw
    playwright
    playwright-test
    brave
  ];
}
