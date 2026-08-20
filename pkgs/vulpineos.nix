{
  lib,
  stdenv,
  stdenvNoCC,
  symlinkJoin,
  fetchurl,
  autoPatchelfHook,
  patchelfUnstable,
  unzip,
  alsa-lib,
  curl,
  dbus-glib,
  gtk3,
  libva,
  libxtst,
  nspr,
  nss,
  pciutils,
  pipewire,
  adwaita-icon-theme,
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxt,
  libxcb,
}: let
  version = "0.1.8-dev.5";
  releaseUrl = "https://github.com/VulpineOS/VulpineOS/releases/download/v${version}";
  cli = fetchurl {
    url = "${releaseUrl}/vulpineos-linux-amd64";
    sha256 = "ccb2ab16b28a07a467c24bf5521a88fea0896bd0bc6bb283f9aa9a47732cd53c";
  };
  browser = fetchurl {
    url = "${releaseUrl}/camoufox-150.0.2-beta.25-lin.x86_64.zip";
    sha256 = "dbd5dcffb2aead79f55ed305adb8e67e923094fc6f4181781bf55330f75d2a48";
  };
  cliPackage = stdenvNoCC.mkDerivation {
    pname = "vulpineos-cli";
    inherit version;
    dontUnpack = true;
    installPhase = ''
      install -Dm755 ${cli} $out/bin/vulpineos
    '';
  };

  browserPackage = stdenv.mkDerivation {
    pname = "vulpineos-browser";
    inherit version;
    dontUnpack = true;

    nativeBuildInputs = [
      autoPatchelfHook
      patchelfUnstable
      unzip
    ];

    buildInputs = [
      adwaita-icon-theme
      alsa-lib
      dbus-glib
      gtk3
      libva
      libxtst
      nspr
      nss
      libx11
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxt
      libxcb
    ];

    runtimeDependencies = [
      curl
      libva.out
      pciutils
    ];

    appendRunpaths = ["${pipewire}/lib"];
    patchelfFlags = ["--no-clobber-old-sections"];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/vulpineos/browser
      unzip -q ${browser} -d $out/lib/vulpineos/browser

      runHook postInstall
    '';
  };
in
  symlinkJoin {
    name = "vulpineos-${version}";
    inherit version;
    paths = [
      cliPackage
      browserPackage
    ];

    passthru = {
      imageTag = version;
    };

    meta = {
      description = "Persistent anti-detect browser kernel for AI agents";
      homepage = "https://github.com/VulpineOS/VulpineOS";
      license = lib.licenses.mpl20;
      mainProgram = "vulpineos";
      platforms = ["x86_64-linux"];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  }
