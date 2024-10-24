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
      userChrome = ''
        :root {
          --tabpanel-background-color: transparent !important;
          background: transparent !important;
        }

#navigator-toolbox, #nav-bar {
          background-color: transparent !important;
        }

        vbox#titlebar {
          * {
              background-color: transparent !important;
          }    
        }
      '';
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
