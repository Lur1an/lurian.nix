{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  ripgrep,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "2.0.30";

  src = fetchurl {
    url = "https://registry.npmjs.org/@opencode/cli-linux-x64-baseline/-/cli-linux-x64-baseline-${finalAttrs.version}.tgz";
    hash = "sha512-TLogU0tVEAyoRlXuqQSuvoeB6dVMy7u0SbM2GV8B0jfu4ErQubTxuZjn5zViX3VUWMoRwt7XzsifO0sysSnBxA==";
  };

  sourceRoot = "package";
  dontConfigure = true;
  dontBuild = true;
  # Preserve the embedded Bun payload in the prebuilt executable.
  dontStrip = true;

  nativeBuildInputs = [makeBinaryWrapper autoPatchelfHook];
  buildInputs = [stdenv.cc.cc.lib];

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
    platforms = ["x86_64-linux"];
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
})
