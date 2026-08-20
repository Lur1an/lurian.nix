{
  lib,
  stdenv,
  buildGoModule,
  symlinkJoin,
  fetchFromGitHub,
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
  browser = fetchurl {
    url = "${releaseUrl}/camoufox-150.0.2-beta.25-lin.x86_64.zip";
    sha256 = "dbd5dcffb2aead79f55ed305adb8e67e923094fc6f4181781bf55330f75d2a48";
  };
  cliPackage = buildGoModule {
    pname = "vulpineos-cli";
    inherit version;

    src = fetchFromGitHub {
      owner = "VulpineOS";
      repo = "VulpineOS";
      rev = "v${version}";
      sha256 = "02ygbczg9kx2wbm20nl8i6ryi4ijgs70yjqr2b6j0nba35b1s1b9";
    };

    patches = [./remote-events.patch];
    vendorHash = "sha256-Cnq27yvsd1aQo9+AFhNfGy9ProWT5zMOmr8PiB+6r9o=";
    subPackages = ["cmd/vulpineos"];
    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];
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
