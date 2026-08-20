{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  ripgrep,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.18.18";

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${finalAttrs.version}/opencode-linux-x64.tar.gz";
    hash = "sha256-DN3CIkGLhVNmmQWomAwM2nCI8A2iTYPWrHawHJ/bKq8=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [makeBinaryWrapper];

  installPhase = ''
    runHook preInstall

    install -Dm755 opencode $out/libexec/opencode
    makeWrapper $out/libexec/opencode $out/bin/opencode \
      --prefix PATH : ${lib.makeBinPath [ripgrep]}

    runHook postInstall
  '';

  meta = {
    description = "The open source coding agent";
    homepage = "https://opencode.ai/";
    license = lib.licenses.mit;
    mainProgram = "opencode";
    platforms = ["x86_64-linux"];
  };
})
