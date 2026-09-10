{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  ripgrep,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode2";
  version = "0.0.0-dev-19449";

  src = fetchurl {
    url = "https://opencode.ai/files/bin/${finalAttrs.version}/opencode2-linux-x64.tar.gz";
    hash = "sha256-/SiaJdfzXtJ8srP3ylcV3qrZ8AFfPTRmGppnHc6IuPg=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [makeBinaryWrapper];

  installPhase = ''
    runHook preInstall

    install -Dm755 opencode2 $out/libexec/opencode2
    makeWrapper $out/libexec/opencode2 $out/bin/opencode2 \
      --prefix PATH : ${lib.makeBinPath [ripgrep]}

    runHook postInstall
  '';

  meta = {
    description = "The open source coding agent (v2 preview)";
    homepage = "https://opencode.ai/";
    license = lib.licenses.mit;
    mainProgram = "opencode2";
    platforms = ["x86_64-linux"];
  };
})
