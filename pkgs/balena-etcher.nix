{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  patchelf,
  # Electron runtime deps
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libnotify,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libxcb,
  libGL,
  gcc-unwrapped,
}: let
  version = "2.1.4";

  runtimeLibs = [
    libGL
    mesa
    systemd
    libxkbcommon
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    gtk3
    dbus
  ];

  etcherUtilLibPath = lib.makeLibraryPath [
    gcc-unwrapped.lib
    stdenv.cc.libc
    systemd
  ];
in
  stdenv.mkDerivation {
    pname = "balena-etcher";
    inherit version;

    src = fetchzip {
      url = "https://github.com/balena-io/etcher/releases/download/v${version}/balenaEtcher-linux-x64-${version}.zip";
      hash = "sha256-ylqowzTfL3Avns1771rLq4G9skPziVisLkx/YwP187U=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
      patchelf
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      libdrm
      libnotify
      libxkbcommon
      mesa
      nspr
      nss
      pango
      systemd
    ];

    runtimeDependencies = runtimeLibs;

    desktopItems = [
      (makeDesktopItem {
        name = "balena-etcher";
        desktopName = "balenaEtcher";
        genericName = "OS Image Flasher";
        comment = "Flash OS images to SD cards and USB drives, safely and easily.";
        exec = "balena-etcher %U";
        icon = "balena-etcher";
        categories = ["Utility"];
        mimeTypes = [
          "application/x-raw-disk-image"
          "application/x-iso9660-image"
        ];
      })
    ];

    dontConfigure = true;
    dontBuild = true;
    # etcher-util is a pkg-compiled Node.js binary with an embedded
    # virtual filesystem. Stripping destroys this embedded data.
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/balena-etcher

      # Save etcher-util to TMPDIR before copying. It is a
      # @yao-pkg/pkg-compiled Node.js binary with a hardcoded payload
      # offset in its ELF trailer. ANY binary modification (patchelf
      # --set-interpreter, --set-rpath, --add-needed, strip) shifts
      # sections and corrupts this offset. The binary must remain
      # byte-identical to the upstream release.
      cp resources/etcher-util $TMPDIR/etcher-util.orig
      rm resources/etcher-util

      cp -r ./* $out/lib/balena-etcher/

      # Remove broken symlink that points to build directory
      rm -f $out/lib/balena-etcher/balenaEtcher

      # Ensure binaries are executable
      chmod +x $out/lib/balena-etcher/balena-etcher
      chmod +x $out/lib/balena-etcher/chrome_crashpad_handler
      chmod +x $out/lib/balena-etcher/chrome-sandbox

      # Register a postFixupHooks function to restore etcher-util
      # AFTER autoPatchelfPostFixup has finished running
      postFixupHooks+=(_restoreEtcherUtil)

      runHook postInstall
    '';

    # Define the restore function early enough that it exists when
    # postFixupHooks runs it
    postUnpack = ''
      _restoreEtcherUtil() {
        echo "Restoring original unpatched etcher-util binary..."

        # Place the original unmodified binary in $out
        cp $TMPDIR/etcher-util.orig $out/lib/balena-etcher/resources/etcher-util.bin
        chmod +x $out/lib/balena-etcher/resources/etcher-util.bin

        # Wrap it with LD_LIBRARY_PATH for its only missing dep
        # (libstdc++). The interpreter is resolved by nix-ld at
        # runtime via /lib64/ld-linux-x86-64.so.2.
        makeWrapper $out/lib/balena-etcher/resources/etcher-util.bin \
          $out/lib/balena-etcher/resources/etcher-util \
          --prefix LD_LIBRARY_PATH : "${etcherUtilLibPath}"
      }
    '';

    postFixup = ''
      # Create the main binary wrapper
      mkdir -p $out/bin
      makeWrapper $out/lib/balena-etcher/balena-etcher $out/bin/balena-etcher \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
        --set ELECTRON_IS_DEV 0 \
        --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}"
    '';

    meta = with lib; {
      description = "Flash OS images to SD cards & USB drives, safely and easily";
      homepage = "https://etcher.balena.io/";
      license = licenses.asl20;
      platforms = ["x86_64-linux"];
      mainProgram = "balena-etcher";
    };
  }
