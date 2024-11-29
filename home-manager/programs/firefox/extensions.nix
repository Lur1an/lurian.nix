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
