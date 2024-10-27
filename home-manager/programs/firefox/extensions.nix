{
  lib,
  pkgs,
}: let
  fetchExt = {
    url,
    sha256,
  }:
    builtins.fetchurl {inherit url sha256;};
  buildFirefoxExtension = {
    pname,
    addonId,
    src,
  }:
    pkgs.stdenv.mkDerivation {
      name = "${pname}";
      src = src;
      dontUnpack = true;
      preferLocalBuild = true;
      allowSubstitutes = true;
      passthru = {inherit addonId;};

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    };
  extensions = {
    "workona" = {
      addonId = "firefox-addon@workona.com";
      src = fetchExt {
        url = "https://addons.mozilla.org/firefox/downloads/file/4240742/workona-3.1.23.xpi";
        sha256 = "01m2kigxp9ym9nf7jbi0djh2fkhdya4x66b4d944bzxz5ci3vl4m";
      };
    };
    "1password" = {
      addonId = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
      src = fetchExt {
        url = "https://addons.mozilla.org/firefox/downloads/file/4370505/1password_x_password_manager-8.10.48.25.xpi";
        sha256 = "0jfg9hl7pkd2fj3809drvpkhc00f929nfypj0xpv1pfnyj1w5nl5";
      };
    };
    "protonpass" = {
      addonId = "78272b6fa58f4a1abaac99321d503a20@proton.me";
      src = fetchExt {
        url = "https://addons.mozilla.org/firefox/downloads/file/4365686/proton_pass-1.23.1.xpi";
        sha256 = "0nbhvz6km078d3hq8r8vn8c59425kdy072acqpqlq52r788ncfv2";
      };
    };
    "protonvpn" = {
      addonId = "vpn@proton.ch";
      src = fetchExt {
        url = "https://addons.mozilla.org/firefox/downloads/file/4370777/proton_vpn_firefox_extension-1.2.3.xpi";
        sha256 = "05z8pkl1vmaiy7gwjd9ad2shmdlbfr8q25prdasyzf0bii34ric5";
      };
    };
    # Custom darkreader
    "darkreader" = {
      addonId = "darkreader@alexhulbert.com";
      src = ./darkreader.xpi;
    };
  };
in
  lib.mapAttrsToList
  (name: value: buildFirefoxExtension (value // {pname = name;}))
  extensions
