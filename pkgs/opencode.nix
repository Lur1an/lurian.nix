{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  ripgrep,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.18.29";

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${finalAttrs.version}/opencode-linux-x64.tar.gz";
    hash = "sha256-6oALf/ViJrcJUhJsn8HiUXykxLVoL9nT+eh0SWl6EZQ=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [makeBinaryWrapper];

  installPhase = ''
    runHook preInstall

    install -Dm755 opencode $out/libexec/opencode
    makeWrapper $out/libexec/opencode $out/bin/opencode \
      --set-default OPENCODE_CONFIG ../opencode.json \
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
