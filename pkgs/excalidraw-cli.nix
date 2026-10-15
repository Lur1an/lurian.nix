{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs,
  makeWrapper,
  chromium,
  util-linux,
}: let
  pnpm = pnpm_11;
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "excalidraw-cli";
    version = "0.2.0";

    src = fetchFromGitHub {
      owner = "excalidraw";
      repo = "cli";
      tag = "v${finalAttrs.version}";
      hash = "sha256-ZZu6xFh0C2GmrnKsBi08vlg9yCjNpetB81pveOKP2pE=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-74UpK2waLl5bAt3SS8vcT/35sDZtRUhR0U9xtF9t9Wc=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
      makeWrapper
    ];

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    doCheck = true;
    nativeCheckInputs = [util-linux];
    checkPhase = ''
      runHook preCheck
      pnpm run typecheck:test
      node --test test/integration.test.ts test/features.test.ts test/update.test.ts test/render-validation.test.ts
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/excalidraw-cli/node_modules"
      cp -r dist package.json "$out/lib/excalidraw-cli/"
      # All other dependencies are bundled by upstream's build script.
      cp -rL node_modules/playwright-core "$out/lib/excalidraw-cli/node_modules/"

      makeWrapper ${lib.getExe nodejs} "$out/bin/excalidraw" \
        --add-flags "$out/lib/excalidraw-cli/dist/main.js" \
        --set-default EXCALIDRAW_BROWSER_PATH ${lib.getExe chromium} \
        --set EXCALIDRAW_NO_UPDATE_NOTIFIER 1

      runHook postInstall
    '';

    meta = {
      description = "Manage Excalidraw workspaces and render scenes locally as PNG";
      homepage = "https://github.com/excalidraw/cli";
      license = lib.licenses.mit;
      mainProgram = "excalidraw";
      platforms = lib.platforms.linux;
    };
  })
