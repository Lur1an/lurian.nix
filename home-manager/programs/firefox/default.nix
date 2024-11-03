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

  imports = [
    ./styling
  ];

  programs.firefox = {
    enable = true;
    # package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;
    package = pkgs.firefox-esr;
    profiles.default = {
      userChrome = ''
        @import url('blurredfox/userChrome.css');
        @import url('blur.css');
        @import url('userContent.css');
        @import url('layout.css');
      '';
      search = {
        default = "DuckDuckGo";
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
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@nw"];
          };
          "YouTube" = {
            urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
            definedAliases = ["@yt"];
          };
          "Spotify" = {
            urls = [{template = "https://open.spotify.com/search/{searchTerms}";}];
            definedAliases = ["@sp"];
          };
          "Wikipedia (en)".metaData.alias = "@wiki";
        };
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "xpinstall.signatures.required" = false;
        "extensions.langpacks.signatures.required" = false;
        "sidebar.revamp" = false;
        "sidebar.verticalTabs" = false;
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
