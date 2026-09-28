{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  ripgrep,
}: let
  sources = {
    x86_64-linux = {
      target = "linux-x64-baseline";
      hash = "sha512-yR7tA8ZAjUzUV3vcBIV1z/zp7KPNV55XQipP9qsQppEApyEv7/NJOIaPK8n+yFl7kogPRk1fQ0fsOW+4KO7mbQ==";
    };
    aarch64-linux = {
      target = "linux-arm64";
      hash = "sha512-OjKG0staG+KRG9sNORb2vIPcfthMVk9RtCamU1vMWPquV70bQEYUM0JUT+t0A49eAc2H4lZWhqkpH2gpg87D+Q==";
    };
    aarch64-darwin = {
      target = "darwin-arm64";
      hash = "sha512-GRJMkkyQKDPIJbYr2WtFTgK1Vb1p/4xrqxgXA/TLyJ1Tn5tK5hNOtbslUZgsktrEQD6TeT5bVZcjRLC41n+d/A==";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system};
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "opencode";
    version = "2.0.18";

    src = fetchurl {
      url = "https://registry.npmjs.org/@opencode/cli-${source.target}/-/cli-${source.target}-${finalAttrs.version}.tgz";
      inherit (source) hash;
    };

    sourceRoot = "package";
    dontConfigure = true;
    dontBuild = true;
    # Preserve the embedded Bun payload in the prebuilt executable.
    dontStrip = true;

    nativeBuildInputs =
      [makeBinaryWrapper]
      ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [autoPatchelfHook];
    buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [stdenv.cc.cc.lib];

    installPhase = ''
      runHook preInstall

      install -Dm755 bin/opencode $out/libexec/opencode
      makeWrapper $out/libexec/opencode $out/bin/opencode \
        --prefix PATH : ${lib.makeBinPath [ripgrep]}

      runHook postInstall
    '';

    meta = {
      description = "The open source coding agent";
      homepage = "https://opencode.ai/v2";
      license = lib.licenses.mit;
      mainProgram = "opencode";
      platforms = builtins.attrNames sources;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  })
