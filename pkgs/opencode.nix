{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  ripgrep,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.17.11";

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${finalAttrs.version}/opencode-linux-x64.tar.gz";
    hash = "sha256-au/Lu38EzbRkK+Ugjdv6uzw9J0+Ba/Qr/3LupcJE3KI=";
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
