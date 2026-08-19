{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
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
  stdenv.mkDerivation rec {
    pname = "balena-etcher";
    version = "2.1.4";

    src = fetchurl {
      url = "https://github.com/balena-io/etcher/releases/download/v${version}/balena-etcher_${version}_amd64.deb";
      hash = "sha256-xjUhO7ByTreJvANoGc0a230Gk/070mYigRqPe9JeklI=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
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

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb --fsys-tarfile $src | tar --extract --file - --no-same-owner --no-same-permissions
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/lib $out/share

      cp -a usr/lib/balena-etcher $out/lib/
      cp -a usr/share/applications usr/share/pixmaps $out/share/

      # This upstream symlink points back into the CI workspace.
      rm -f $out/lib/balena-etcher/balenaEtcher

      # etcher-util is a pkg-compiled Node.js binary. patchelf/strip corrupts
      # its embedded payload offset, so keep it byte-identical and wrap it after
      # autoPatchelfHook has processed the rest of the app.
      mv $out/lib/balena-etcher/resources/etcher-util $TMPDIR/etcher-util
      postFixupHooks+=(_restoreEtcherUtil)

      runHook postInstall
    '';

    postUnpack = ''
      _restoreEtcherUtil() {
        cp $TMPDIR/etcher-util $out/lib/balena-etcher/resources/etcher-util.bin
        chmod +x $out/lib/balena-etcher/resources/etcher-util.bin

        makeWrapper $out/lib/balena-etcher/resources/etcher-util.bin \
          $out/lib/balena-etcher/resources/etcher-util \
          --prefix LD_LIBRARY_PATH : "${etcherUtilLibPath}"
      }
    '';

    postFixup = ''
      makeWrapper $out/lib/balena-etcher/balena-etcher $out/bin/balena-etcher \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
        --set ELECTRON_IS_DEV 0 \
        --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}"
    '';

    meta = with lib; {
      description = "Flash OS images to SD cards and USB drives, safely and easily";
      homepage = "https://etcher.balena.io/";
      license = licenses.asl20;
      platforms = ["x86_64-linux"];
      mainProgram = "balena-etcher";
    };
  }
