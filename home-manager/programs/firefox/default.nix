{
  pkgs,
  inputs,
  lib,
  ...
}: let
  addons = inputs.rycee-nurpkgs.packages.${pkgs.system};
in {
  home = {
    sessionVariables.BROWSER = "firefox";
  };

  programs.librewolf = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;
    profiles.default = {
      search = {
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "Nix Options" = {
            definedAliases = ["@no"];
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "xpinstall.signatures.required" = false;
        "extensions.langpacks.signatures.required" = false;
        "sidebar.revamp" = true;
        "browser.bookmarks.addedImportButton" = false;
        "sidebar.verticalTabs" = true;
        "browser.aboutConfig.showWarning" = false;
      };
      extensions =
        (with addons; [
          vimium
          pywalfox
          ublock-origin
          cookie-quick-manager
          sponsorblock
          clearcache
        ])
        ++ pkgs.callPackage ./extensions.nix {inherit lib pkgs;};
    };
    policies = {
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisplayBookmarksToolbar = "newtab";
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
    };
  };
}
