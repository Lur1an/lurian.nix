{pkgs, ...}: {
  home = {
    sessionVariables.BROWSER = "firefox";
  };

  programs.librewolf = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Preferences = {
        "sidebar.revamp" = false;
        "sidebar.verticalTabs" = false;
      };
    };
  };
}
