{
  lib,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "supermaven-agent";
  version = "8";

  src = fetchurl {
    url = "https://supermaven-public.s3.amazonaws.com/sm-agent/v2/8/linux-musl/x86_64/sm-agent";
    hash = "sha256-lsaS7IoNQUIkTL1Qo+UymeD8y4eX4mPR6XFC2qMlp4g=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/sm-agent"

    runHook postInstall
  '';

  meta = {
    description = "Native completion agent used by Supermaven editor integrations";
    homepage = "https://supermaven.com/";
    license = lib.licenses.unfree;
    mainProgram = "sm-agent";
    platforms = ["x86_64-linux"];
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
}
