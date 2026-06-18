{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    playwright
    playwright-test
    brave
  ];
}
