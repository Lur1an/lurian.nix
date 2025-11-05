{pkgs, ...}: {
  home = {
    sessionVariables.BROWSER = "firefox";
  };

  imports = [];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles.default = {
      search = {
        default = "ddg";
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
                  {
                    name = "channel";
                    value = "unstable";
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
                  {
                    name = "channel";
                    value = "unstable";
                  }
                ];
              }
            ];
          };
          "My NixOs" = {
            definedAliases = ["@mn"];
            urls = [
              {
                template = "https://mynixos.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@nw"];
          };
          "youtube" = {
            urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
            definedAliases = ["@yt"];
          };
          "Spotify" = {
            urls = [{template = "https://open.spotify.com/search/{searchTerms}";}];
            definedAliases = ["@sp"];
          };
          "wikipedia".metaData.alias = "@wiki";
        };
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "xpinstall.signatures.required" = false;
        "extensions.langpacks.signatures.required" = false;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "browser.bookmarks.addedImportButton" = false;
        "layers.acceleration.force-enabled" = true;
        "apz.gtk.kinetic_scroll.enabled" = false;
        "gfx.webrender.all" = true;
        "gfx.webrender.enabled" = true;
        "layout.css.backdrop-filter.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "dom.w3c_touch_events.enabled" = 1;
        "widget.use-xdg-desktop-portal" = true;
        "browser.aboutConfig.showWarning" = false;
      };
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
