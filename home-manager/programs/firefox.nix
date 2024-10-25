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
    profiles.default = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
    policies = {
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
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
