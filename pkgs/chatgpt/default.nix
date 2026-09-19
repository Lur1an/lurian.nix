# Adapted from kadencartwright/openai-chatgpt-desktop-nix at
# 2f0b60bf86e7a70ae3f6a9945c4e35cfbe9386d7; see LICENSE for packaging terms.
{
  lib,
  stdenv,
  fetchurl,
  asar,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  cairo,
  coreutils,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  git,
  glib,
  graphite2,
  gtk3,
  libGL,
  libdrm,
  libgbm,
  libnotify,
  libpulseaudio,
  libusb1,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  openssl,
  pango,
  pciutils,
  systemd,
  tectonic,
  tpm2-tss,
  vulkan-loader,
  wayland,
  xdg-utils,
  xz,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "chatgpt";
  version = "26.915.31945";

  # Version and SHA-256 from OpenAI's official Debian repository:
  # https://persistent.oaistatic.com/codex-app-prod/linux/deb/dists/stable/main/binary-amd64/Packages
  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${finalAttrs.version}_amd64.deb";
    hash = "sha256-0nqcApGc/khNzF80WEueqf0NemXGncyHK1vc+g77WYM=";
  };

  nativeBuildInputs = [
    asar
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    graphite2
    gtk3
    libGL
    libdrm
    libgbm
    libnotify
    libusb1
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    openssl
    pango
    pciutils
    stdenv.cc.cc
    systemd
    tpm2-tss
    vulkan-loader
  ];

  # Electron loads these libraries with dlopen rather than ELF dependencies.
  runtimeDependencies = map lib.getLib [
    libGL
    libnotify
    libpulseaudio
    systemd
    wayland
  ];

  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x "$src" .

    runHook postUnpack
  '';

  postPatch = ''
    # fs.cp preserves the store's read-only modes. The plugin installer then
    # edits its private copy, so restore owner-write permission there only.
    # chmod -R does not follow symlinks back into the store.
    asar extract usr/lib/chatgpt/resources/app.asar app
    substituteInPlace app/.vite/build/main-*.js \
      --replace-fail \
        'await b.default.cp(e,t,{recursive:!0,verbatimSymlinks:!0});return' \
        'await b.default.cp(e,t,{recursive:!0,verbatimSymlinks:!0});await cre(`${coreutils}/bin/chmod`,[`-R`,`u+w`,`--`,t]);return'
    asar pack app usr/lib/chatgpt/resources/app.asar --unpack-dir node_modules
    rm -r app
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib" "$out/share"
    cp -a usr/lib/chatgpt "$out/lib/"
    cp -a usr/share/applications usr/share/pixmaps "$out/share/"

    # The bundled Tectonic ELF cannot be rewritten by patchelf. Keep the LaTeX
    # plugin working with nixpkgs' native build instead of an FHS loader.
    rm "$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/latex/bin/tectonic"
    ln -s "${lib.getExe tectonic}" \
      "$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/latex/bin/tectonic"

    install -Dm755 ${./chatgpt.sh} "$out/bin/chatgpt"
    install -Dm644 ${./LICENSE} "$out/share/doc/chatgpt/packaging-LICENSE"
    substituteInPlace "$out/bin/chatgpt" \
      --replace-fail "@out@" "$out"
    substituteInPlace "$out/share/applications/chatgpt.desktop" \
      --replace-fail "Exec=chatgpt " "Exec=$out/bin/chatgpt "

    runHook postInstall
  '';

  preFixup = ''
    rm "$out/lib/chatgpt/libvulkan.so.1"
    ln -s "${lib.getLib vulkan-loader}/lib/libvulkan.so.1" \
      "$out/lib/chatgpt/libvulkan.so.1"

    wrapProgram "$out/bin/chatgpt" \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : "${lib.makeBinPath [git xdg-utils xz]}"
  '';

  # Optional Qt integration shims and musl prebuilds are not used by the
  # supported glibc/GTK build. All other missing libraries remain errors.
  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
    "libc.musl-x86_64.so.1"
  ];

  meta = {
    description = "OpenAI ChatGPT desktop app with Codex";
    homepage = "https://learn.chatgpt.com/docs/linux/linux-app";
    license = lib.licenses.unfree;
    mainProgram = "chatgpt";
    platforms = ["x86_64-linux"];
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  };
})
